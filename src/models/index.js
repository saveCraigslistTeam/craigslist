// @ts-check
import { initSchema } from '@aws-amplify/datastore';
import { schema } from './schema';



const { Messages, SaleImage, Sale } = initSchema(schema);

export {
  Messages,
  SaleImage,
  Sale
};