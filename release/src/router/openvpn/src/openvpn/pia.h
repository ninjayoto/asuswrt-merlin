void pia_obfuscate_options(char *buf, int len) {
  char xor_key[3] = {rand()%256, rand()%256, rand()%256};
  memcpy(buf, xor_key, 3);
  int i,j; for (i = 3, j = 0; i < len; i++, j++)  buf[i] ^= xor_key[j%3];
}

char *pia_cert_digest(char *data, int len) {
  BIO *bio; X509 *cert;
  uint8_t md5[16], md5hex[33];

  bio = BIO_new_mem_buf(data, len);
  cert = PEM_read_bio_X509(bio, NULL, NULL, NULL);
  BIO_free(bio);
  if (!cert)  return NULL;

  X509_digest(cert, EVP_get_digestbyname("md5"), md5, NULL);
  int i; for (i = 0; i < 16; i++)  sprintf(&md5hex[i*2], "%02x", md5[i]);
  return strdup(md5hex);
}
