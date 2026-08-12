import jwt from 'jsonwebtoken';
import bcrypt from 'bcryptjs';
import UserRepository from '../repositories/UserRepository.js';
import ProfileRepository from '../repositories/ProfileRepository.js';
import { sendOTPEmail } from '../utils/mailer.js';

class AuthService {
  generateToken(userId) {
    return jwt.sign({ id: userId }, process.env.JWT_SECRET, {
      expiresIn: '30d',
    });
  }

  generate4DigitOTP() {
    return Math.floor(1000 + Math.random() * 9000).toString(); // 4 digit code
  }

  async getMergedUser(user) {
    const userJson = user.toObject();
    delete userJson.password;

    const profile = await ProfileRepository.findByUserId(user._id);
    if (profile) {
      const profileJson = profile.toObject();
      delete profileJson._id;
      delete profileJson.userId;
      delete profileJson.createdAt;
      delete profileJson.updatedAt;
      return {
        ...userJson,
        ...profileJson,
        id: user._id.toString()
      };
    }
    return {
      ...userJson,
      id: user._id.toString()
    };
  }

  async checkUser(checkData) {
    const { email, phone, identifier } = checkData;
    let user = null;

    if (email) {
      user = await UserRepository.findByEmail(email);
    } else if (phone) {
      user = await UserRepository.findByPhone(phone);
    } else if (identifier) {
      if (identifier.includes('@')) {
        user = await UserRepository.findByEmail(identifier);
      } else {
        user = await UserRepository.findByPhone(identifier);
      }
    }

    return { exists: !!user };
  }

  async sendOTP(otpData) {
    const { email, phone } = otpData;
    let user;

    if (email) {
      user = await UserRepository.findByEmail(email);
    } else if (phone) {
      user = await UserRepository.findByPhone(phone);
    }

    if (!user) {
      const error = new Error('User not found');
      error.statusCode = 404;
      throw error;
    }

    const otpCode = this.generate4DigitOTP();
    const otpExpiresAt = new Date(Date.now() + 5 * 60 * 1000); // 5 minutes expiration

    user.otp = {
      code: otpCode,
      expiresAt: otpExpiresAt,
      type: 'login',
    };
    await UserRepository.save(user);

    // Send OTP via email if email is registered
    if (user.email) {
      try {
        await sendOTPEmail(user.email, otpCode);
      } catch (err) {
        console.error('Failed to send email:', err);
      }
    }

    // ALWAYS log the OTP code to console for easy development/testing
    console.log('\n==================================================');
    console.log(`[OTP LOGIN SIMULATION]`);
    console.log(`Target: ${user.email || user.phone}`);
    console.log(`Generated OTP Code: ${otpCode}`);
    console.log('==================================================\n');

    return { success: true, message: 'OTP sent successfully' };
  }

  async loginUser(loginData) {
    const { email, phoneNumber } = loginData;
    const phone = phoneNumber;
    let user;

    if (email) {
      user = await UserRepository.findByEmail(email);
    } else if (phone) {
      user = await UserRepository.findByPhone(phone);
    }

    if (!user) {
      const createData = {};
      if (email) createData.email = email;
      if (phone) createData.phone = phone;
      createData.isVerified = false;
      createData.profileCompleted = false;
      user = await UserRepository.create(createData);
    }

    return await this.sendOTP({ email: user.email, phone: user.phone });
  }

  async verifyOTP(verifyData) {
    const { email, phoneNumber, code } = verifyData;
    const phone = phoneNumber;
    let user;

    if (email) {
      user = await UserRepository.findByEmail(email);
    } else if (phone) {
      user = await UserRepository.findByPhone(phone);
    }

    if (!user) {
      const error = new Error('User not found');
      error.statusCode = 404;
      throw error;
    }

    if (!user.otp || user.otp.code !== code || user.otp.type !== 'login') {
      const error = new Error('Invalid OTP code');
      error.statusCode = 401;
      throw error;
    }

    if (new Date() > user.otp.expiresAt) {
      const error = new Error('OTP has expired');
      error.statusCode = 401;
      throw error;
    }

    user.isVerified = true;
    user.otp = undefined;
    await UserRepository.save(user);

    const token = this.generateToken(user._id);
    const mergedUser = await this.getMergedUser(user);

    return {
      token,
      profileCompleted: user.profileCompleted,
      user: mergedUser
    };
  }

  async completeRegistration(userId, registrationData) {
    const {
      email,
      phone,
      password,
      accountType,
      fullName,
      gender,
      dob,
      religion,
      caste,
      maritalStatus,
      bloodGroup,
      address,
      hobbies,
      rashi,
      nakshatra,
      manglik,
      qualification,
      occupation,
      annualIncome,
      country,
      state,
      city,
      languages,
      fatherName,
      motherName,
      siblings,
      familyType,
      familyStatus,
      nativePlace,
      aboutFamily,
      aadharNumber,
      aadharCardUrl,
      photos
    } = registrationData;

    let user;

    if (userId) {
      user = await UserRepository.findById(userId);
    }

    if (!user) {
      if (email) {
        user = await UserRepository.findByEmail(email);
      }
      if (!user && phone) {
        user = await UserRepository.findByPhone(phone);
      }
    }

    if (!user) {
      const newUser = {
        email,
        phone,
        isVerified: true,
        profileCompleted: true
      };
      user = await UserRepository.create(newUser);
    } else {
      if (user.profileCompleted) {
        const error = new Error('An account with this email or phone number already has a completed profile.');
        error.statusCode = 400;
        throw error;
      }
      if (email) user.email = email;
      if (phone) user.phone = phone;
      user.profileCompleted = true;
      user.isVerified = true;
    }

    if (password) {
      const salt = await bcrypt.genSalt(10);
      user.password = await bcrypt.hash(password, salt);
    }
    await UserRepository.save(user);

    let calculatedAge = 0;
    let birthDate;
    if (dob) {
      birthDate = new Date(dob);
      const today = new Date();
      calculatedAge = today.getFullYear() - birthDate.getFullYear();
      const monthDifference = today.getMonth() - birthDate.getMonth();
      if (monthDifference < 0 || (monthDifference === 0 && today.getDate() < birthDate.getDate())) {
        calculatedAge--;
      }
    }

    const profileDetails = {
      userId: user._id,
      accountType,
      fullName,
      gender,
      dob: birthDate,
      age: calculatedAge,
      religion,
      caste,
      maritalStatus,
      bloodGroup,
      address,
      hobbies: hobbies || [],
      rashi,
      nakshatra,
      manglik: manglik !== undefined ? manglik : false,
      qualification,
      occupation,
      annualIncome,
      country,
      state,
      city,
      languages: languages || [],
      fatherName,
      motherName,
      siblings: siblings || 0,
      familyType,
      familyStatus,
      nativePlace,
      aboutFamily,
      aadharNumber,
      aadharCardUrl,
      photos: photos || [],
      partnerPreference: {}
    };

    await ProfileRepository.updateByUserId(user._id, profileDetails);

    const token = this.generateToken(user._id);
    const mergedUser = await this.getMergedUser(user);

    return {
      token,
      user: mergedUser
    };
  }
}

export default new AuthService();
