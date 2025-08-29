table 81240 Webportal_UpdateFun
{
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "PO No."; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(2; "PO Line No."; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(30; "Quantity to Send"; Integer)
        {
            DataClassification = ToBeClassified;
        }
        field(40; "Shipment No."; Code[20])
        {
            DataClassification = ToBeClassified;
        }

    }
    keys
    {
        key(pk; "PO No.", "PO Line No.")
        {
            Clustered = true;
        }
    }
}