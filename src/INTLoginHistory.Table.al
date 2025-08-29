table 81231 "INT - Login History"
{
    // version WebPortal


    fields
    {
        field(70144598; "Entry No."; Integer)
        {
            AutoIncrement = true;
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(70144599; "User ID"; Code[80])
        {
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(70144600; Name; Text[80])
        {
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(70144601; "Login Type"; Option)
        {
            DataClassification = CustomerContent;
            Editable = false;
            OptionCaption = ' ,Customer,Vendor,SalesPerson';
            OptionMembers = " ",Customer,Vendor,SalesPerson;
        }
        field(70144602; "Account No."; Code[20])
        {
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(70144603; "Login DateTime"; DateTime)
        {
            DataClassification = CustomerContent;
            Editable = false;
        }
    }

    keys
    {
        key(Key1; "Entry No.")
        {
        }
    }

    fieldgroups
    {
    }
}

