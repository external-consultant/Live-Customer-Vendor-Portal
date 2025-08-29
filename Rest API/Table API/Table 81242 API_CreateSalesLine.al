table 81242 API_CreateSalesLine
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
        field(3; "Line No"; Integer)
        {
            DataClassification = ToBeClassified;
        }
        field(5; "Customer No"; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(4; "Item No"; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(30; "Description"; Text[50])
        {
            DataClassification = ToBeClassified;
        }
        field(40; "Description 2"; Text[50])
        {
            DataClassification = ToBeClassified;
        }
        field(50; "Quantity"; Integer)
        {
            DataClassification = ToBeClassified;
        }
        field(60; "Request Receipt Date"; Date)
        {
            DataClassification = ToBeClassified;
        }
        field(70; "Location Code"; Code[20])
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