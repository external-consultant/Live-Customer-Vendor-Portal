table 81241 API_CreateSalesOrder
{
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "Entry No"; Integer)
        {
            AutoIncrement = true;
            DataClassification = ToBeClassified;
        }
        field(2; "Customer No"; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(30; "Order Date"; Date)
        {
            DataClassification = ToBeClassified;
        }
        field(40; "Reference No"; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(50; "Remarks"; Text[100])
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