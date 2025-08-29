table 81245 API_PurchLineDeliveryDateUpd
{
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
        field(30; "Line No"; Integer)
        {
            DataClassification = ToBeClassified;
        }
        field(40; "Estimated Delivery Date"; Date)
        {
            DataClassification = ToBeClassified;
        }
        //T13751-NS

        //T13751-NE
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