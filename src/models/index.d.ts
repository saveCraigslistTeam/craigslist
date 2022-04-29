import { ModelInit, MutableModel, PersistentModelConstructor } from "@aws-amplify/datastore";





type MessagesMetaData = {
  readOnlyFields: 'createdAt' | 'updatedAt';
}

type SaleImageMetaData = {
  readOnlyFields: 'createdAt' | 'updatedAt';
}

type SaleMetaData = {
  readOnlyFields: 'createdAt' | 'updatedAt';
}

export declare class Messages {
  readonly id: string;
  readonly sale?: string | null;
  readonly host?: string | null;
  readonly customer?: string | null;
  readonly sender?: string | null;
  readonly receiver?: string | null;
  readonly senderSeen?: boolean | null;
  readonly receiverSeen?: boolean | null;
  readonly text?: string | null;
  readonly date?: string | null;
  readonly createdAt?: string | null;
  readonly updatedAt?: string | null;
  constructor(init: ModelInit<Messages, MessagesMetaData>);
  static copyOf(source: Messages, mutator: (draft: MutableModel<Messages, MessagesMetaData>) => MutableModel<Messages, MessagesMetaData> | void): Messages;
}

export declare class SaleImage {
  readonly id: string;
  readonly imageURL?: string | null;
  readonly saleID: string;
  readonly createdAt?: string | null;
  readonly updatedAt?: string | null;
  constructor(init: ModelInit<SaleImage, SaleImageMetaData>);
  static copyOf(source: SaleImage, mutator: (draft: MutableModel<SaleImage, SaleImageMetaData>) => MutableModel<SaleImage, SaleImageMetaData> | void): SaleImage;
}

export declare class Sale {
  readonly id: string;
  readonly title?: string | null;
  readonly description?: string | null;
  readonly condition?: string | null;
  readonly zipcode?: string | null;
  readonly price?: string | null;
  readonly SaleImages?: (SaleImage | null)[] | null;
  readonly createdAt?: string | null;
  readonly updatedAt?: string | null;
  constructor(init: ModelInit<Sale, SaleMetaData>);
  static copyOf(source: Sale, mutator: (draft: MutableModel<Sale, SaleMetaData>) => MutableModel<Sale, SaleMetaData> | void): Sale;
}