table 81232 "INT -Check Information"
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
        field(70144599; "User ID"; Code[50])
        {
            DataClassification = CustomerContent;
            TableRelation = "User Setup";
        }
        field(70144600; "Login Type"; Option)
        {
            DataClassification = CustomerContent;
            OptionCaption = ' ,Customer,Vendor';
            OptionMembers = " ",Customer,Vendor;
        }
        field(70144601; "Account No."; Code[20])
        {
            DataClassification = CustomerContent;
            TableRelation = if ("Login Type" = filter(Customer)) Customer
            else
            if ("Login Type" = filter(Vendor)) Vendor;
        }
        field(70144602; "Payment Type"; Option)
        {
            DataClassification = CustomerContent;
            OptionCaption = ' ,Check,NEFT,RTGS,CASH';
            OptionMembers = " ",Check,NEFT,RTGS,CASH;
        }
        field(70144603; "Check No."; Text[30])
        {
            DataClassification = CustomerContent;
            trigger OnValidate()
            begin
                if Rec."Check No." <> '' then
                    TestField("Payment Type", "Payment Type"::Check);
            end;
        }
        field(70144604; "Check Date"; Date)
        {
            DataClassification = CustomerContent;
            trigger OnValidate()
            begin
                if Rec."Check No." <> '' then
                    TestField("Payment Type", "Payment Type"::Check);
            end;
        }
        field(70144605; "Check Issue By"; Text[50])
        {
            DataClassification = CustomerContent;
        }
        field(70144606; "Check Received By"; Text[50])
        {
            DataClassification = CustomerContent;
        }
        field(70144607; "Bank Name"; Text[50])
        {
            DataClassification = CustomerContent;
        }
        field(70144608; "Bank Branch Name"; Text[50])
        {
            DataClassification = CustomerContent;
        }
        field(70144609; "NEFT/RTGS Reference No."; Text[50])
        {
            DataClassification = CustomerContent;
        }
        field(70144610; Amount; Decimal)
        {
            DataClassification = CustomerContent;
        }
        field(70144611; Posted; Boolean)
        {
            DataClassification = CustomerContent;
        }
        field(70144612; "Last Modified By"; Code[50])
        {
            DataClassification = CustomerContent;
            Editable = false;
            TableRelation = "User Setup";
        }
        field(70144613; "Last Modified Date Time"; DateTime)
        {
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(70144614; "Created By"; Code[50])
        {
            DataClassification = CustomerContent;
            Editable = false;
            TableRelation = "User Setup";
        }
        field(70144615; "Created By Date Time"; DateTime)
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

    trigger OnInsert()
    begin
        Evaluate("User ID", UserId());
        Evaluate("Created By", UserId());
        "Created By Date Time" := CurrentDateTime();
    end;

    trigger OnModify()
    begin
        Evaluate("Last Modified By", UserId());
        "Last Modified Date Time" := CurrentDateTime();
    end;
}

