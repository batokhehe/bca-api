const String API_BASE_URL = 'https://devapi.klikbca.com:9443';
const String CLIENT_ID = '76c97d77-44d9-46c4-bb45-87e807b72c93';
const String CLIENT_SECRET = '0aada6ed-f1d5-48c3-8ea5-a9110120b02b';
const String CHANNEL_ID = '95051';
const String PARTNER_ID = 'uatcorp001';

const String HTTP_METHOD_POST = 'POST';

const String API_ACCESS_TOKEN = '$API_BASE_URL/openapi/v1.0/access-token/b2b';
const String ENDPOINT_TRANSFER_INTERBANK = '/openapi/v2.0/transfer-interbank';
const String ENDPOINT_TRANSFER_RTGS = '/openapi/v1.0/transfer-rtgs';
const String ENDPOINT_TRANSFER_SKN = '/openapi/v1.0/transfer-skn';
const String ENDPOINT_TRANSFER_ACCOUNT_BALANCE =
    '/openapi/v1.0/balance-inquiry';
const String ENDPOINT_TRANSFER_INTRABANK =
    '/openapi/v1.0/transfer-intrabank';
const String API_TRANSFER_INTERBANK =
    '$API_BASE_URL$ENDPOINT_TRANSFER_INTERBANK';
const String API_TRANSFER_RTGS = '$API_BASE_URL$ENDPOINT_TRANSFER_RTGS';
const String API_TRANSFER_SKN = '$API_BASE_URL$ENDPOINT_TRANSFER_SKN';
const String API_ACCOUNT_BALANCE =
    '$API_BASE_URL$ENDPOINT_TRANSFER_ACCOUNT_BALANCE';
const String API_TRANSFER_INTRABANK =
    '$API_BASE_URL$ENDPOINT_TRANSFER_INTRABANK';
