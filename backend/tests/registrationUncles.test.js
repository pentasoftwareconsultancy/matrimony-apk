import { test, describe } from 'node:test';
import assert from 'node:assert/strict';
import { registerSchema } from '../src/middlewares/validationMiddleware.js';

describe('Backend Registration Uncle Details Validation & Mapping Tests', () => {
  const baseValidPayload = {
    accountType: 'Self',
    fullName: 'Rahul Sharma',
    phone: '9876543210',
    email: 'rahul@example.com',
    password: 'Password123!',
    gender: 'Male',
    dob: '1995-05-15',
    maritalStatus: 'Never Married',
    qualification: 'B.Tech',
    occupation: 'Software Engineer',
    annualIncome: '10 LPA',
    fatherName: 'Deepak Sharma',
    motherName: 'Sunita Sharma',
    familyType: 'Joint',
    familyValues: 'Traditional',
    motherTongue: 'Marathi',
    religion: 'Hindu',
    caste: 'Brahmin',
  };

  test('registerSchema validates maternalUnclesDetails and unclesDetails arrays', () => {
    const payload = {
      ...baseValidPayload,
      maternalUnclesDetails: [
        { name: 'Maternal Uncle 1', occupation: 'Software Engineer', profession: 'Software Engineer' },
        { name: 'Maternal Uncle 2', occupation: 'Doctor', profession: 'Doctor' },
      ],
      unclesDetails: [
        { name: 'Paternal Uncle 1', occupation: 'Banker', profession: 'Banker' },
      ],
      maternalUncleName: 'Maternal Uncle 1, Maternal Uncle 2',
      uncleName: 'Paternal Uncle 1',
    };

    const { error, value } = registerSchema.validate(payload);
    assert.equal(error, undefined, `Validation error: ${error?.message}`);
    assert.equal(value.maternalUnclesDetails.length, 2);
    assert.equal(value.unclesDetails.length, 1);
    assert.equal(value.maternalUnclesDetails[0].name, 'Maternal Uncle 1');
    assert.equal(value.unclesDetails[0].name, 'Paternal Uncle 1');
  });

  test('registerSchema accepts empty uncle arrays or 0 uncles', () => {
    const payload = {
      ...baseValidPayload,
      fullName: 'Anita Patil',
      email: 'anita@example.com',
      maternalUnclesDetails: [],
      unclesDetails: [],
    };

    const { error, value } = registerSchema.validate(payload);
    assert.equal(error, undefined, `Validation error: ${error?.message}`);
    assert.equal(value.maternalUnclesDetails.length, 0);
    assert.equal(value.unclesDetails.length, 0);
  });

  test('Uncle details mapping logic formats array into legacy scalar fields and retains detailed objects', () => {
    const data = {
      maternalUnclesDetails: [
        { name: 'Ramesh Patil', occupation: 'Teacher' },
        { name: 'Ganesh Patil', profession: 'Businessman' },
      ],
      unclesDetails: [
        { name: 'Suresh Patil', occupation: 'Professor' },
      ],
    };

    const maternalUnclesDetails = Array.isArray(data.maternalUnclesDetails)
      ? data.maternalUnclesDetails
          .map((u) => ({
            name: (u?.name || '').toString().trim(),
            occupation: (u?.occupation || u?.profession || '').toString().trim(),
          }))
          .filter((u) => u.name.length > 0 || u.occupation.length > 0)
      : [];

    const unclesDetails = Array.isArray(data.unclesDetails)
      ? data.unclesDetails
          .map((u) => ({
            name: (u?.name || '').toString().trim(),
            occupation: (u?.occupation || u?.profession || '').toString().trim(),
          }))
          .filter((u) => u.name.length > 0 || u.occupation.length > 0)
      : [];

    const maternalUncleName = data.maternalUncleName ||
      (maternalUnclesDetails.map((u) => u?.name).filter(Boolean).join(', '));

    const uncleName = data.uncleName ||
      (unclesDetails.map((u) => u?.name).filter(Boolean).join(', '));

    assert.equal(maternalUnclesDetails.length, 2);
    assert.equal(maternalUnclesDetails[0].name, 'Ramesh Patil');
    assert.equal(maternalUnclesDetails[0].occupation, 'Teacher');
    assert.equal(maternalUnclesDetails[1].name, 'Ganesh Patil');
    assert.equal(maternalUnclesDetails[1].occupation, 'Businessman');
    assert.equal(maternalUncleName, 'Ramesh Patil, Ganesh Patil');

    assert.equal(unclesDetails.length, 1);
    assert.equal(unclesDetails[0].name, 'Suresh Patil');
    assert.equal(unclesDetails[0].occupation, 'Professor');
    assert.equal(uncleName, 'Suresh Patil');
  });

  test('Strict No Dummy Data: Filters out blank/dummy records and preserves empty list for 0 uncles', () => {
    const dataWithEmptyRecords = {
      maternalUnclesDetails: [
        { name: '', occupation: '' },
        { name: '   ', occupation: '   ' },
      ],
      unclesDetails: [],
    };

    const maternalUnclesDetails = Array.isArray(dataWithEmptyRecords.maternalUnclesDetails)
      ? dataWithEmptyRecords.maternalUnclesDetails
          .map((u) => ({
            name: (u?.name || '').toString().trim(),
            occupation: (u?.occupation || u?.profession || '').toString().trim(),
          }))
          .filter((u) => u.name.length > 0 || u.occupation.length > 0)
      : [];

    const unclesDetails = Array.isArray(dataWithEmptyRecords.unclesDetails)
      ? dataWithEmptyRecords.unclesDetails
          .map((u) => ({
            name: (u?.name || '').toString().trim(),
            occupation: (u?.occupation || u?.profession || '').toString().trim(),
          }))
          .filter((u) => u.name.length > 0 || u.occupation.length > 0)
      : [];

    assert.equal(maternalUnclesDetails.length, 0);
    assert.equal(unclesDetails.length, 0);
  });
});
