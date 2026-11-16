/**
 * Resolves the required JWT signing/verification secret from the environment.
 * Fails closed at boot and on token operations if JWT_SECRET is missing or blank.
 */
export function getJwtSecret() {
  const secret = process.env.JWT_SECRET?.trim();
  if (!secret) {
    throw new Error('FATAL: JWT_SECRET environment variable is required');
  }
  return secret;
}

