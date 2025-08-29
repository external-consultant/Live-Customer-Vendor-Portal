table 81247 API_PurchLineDetailUpdate
{
    //T13751-N
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "Entry No"; Integer)
        {
            AutoIncrement = true;
            DataClassification = ToBeClassified;
        }
        field(2; "Document No"; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(3; "Line No"; Integer)
        {
            DataClassification = ToBeClassified;
        }
        field(30; "Direct Unit Cost"; Decimal)
        {
            DataClassification = ToBeClassified;
            //DecimalPlaces = 0 : 5;
        }
        field(40; ETD; Date)
        {
            DataClassification = ToBeClassified;
        }
        field(50; "Qty. to Receive"; Decimal)
        {
            DataClassification = ToBeClassified;
            //DecimalPlaces = 0 : 5;
        }
        field(60; "Vendor Shipment No."; Code[35])
        {
            DataClassification = ToBeClassified;
        }
        field(70; "Attachment File Name"; Text[1000])
        {
            DataClassification = ToBeClassified;
        }
        field(80; "Attachment File Extension"; Enum "Document Attachment File Type")
        {
            DataClassification = ToBeClassified;
        }
        field(99910; "Process Status"; Option)
        {
            DataClassification = ToBeClassified;
            Editable = false;
            OptionCaption = ' ,Success,Failed';
            OptionMembers = " ",Success,Failed;
        }
        field(99920; "Process DateTime"; DateTime)
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(99930; "Process User ID"; Code[50])
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(99940; "Process Error Log"; Text[250])
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }

    }
    keys
    {
        key(pk; "Entry No")
        {
            Clustered = true;
        }
    }
}