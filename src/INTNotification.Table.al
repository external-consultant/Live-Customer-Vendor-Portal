table 81233 "INT - Notification"
{
    // version WebPortal

    DrillDownPageId = "INT - Notification";
    LookupPageId = "INT - Notification";

    fields
    {
        field(70144598; "Entry No"; Integer)
        {
            AutoIncrement = true;
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(70144599; Date; Date)
        {
            DataClassification = CustomerContent;
        }
        field(70144600; "Notification Type"; Option)
        {
            DataClassification = CustomerContent;
            OptionCaption = ' ,All,Accounts';
            OptionMembers = " ",All,Accounts;
        }
        field(70144601; Notification; Text[250])
        {
            DataClassification = CustomerContent;
        }
        field(70144602; "Login Type"; Option)
        {
            DataClassification = CustomerContent;
            OptionCaption = ' ,Customer,Vendor';
            OptionMembers = " ",Customer,Vendor;
        }
        field(70144603; "Account No."; Code[20])
        {
            DataClassification = CustomerContent;
            TableRelation = if ("Login Type" = filter(Customer)) Customer
            else
            if ("Login Type" = filter(Vendor)) Vendor;
        }
        field(70144604; Activate; Boolean)
        {
            DataClassification = CustomerContent;
            Editable = false;

            trigger OnValidate()
            begin
                if Activate then
                    "Activate DateTime" := CurrentDateTime();
            end;
        }
        field(70144605; "Activate DateTime"; DateTime)
        {
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(70144606; "Close By User"; Boolean)
        {
            DataClassification = CustomerContent;
            Editable = false;

            trigger OnValidate()
            begin
                if "Close By User" then
                    "Close By User DateTime" := CurrentDateTime();
            end;
        }
        field(70144607; "Close By User DateTime"; DateTime)
        {
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(70144608; "Last Modified By"; Code[50])
        {
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(70144609; "Last Modified Date Time"; DateTime)
        {
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(70144610; "Created By"; Code[50])
        {
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(70144611; "Created By Date Time"; DateTime)
        {
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(70144612; "Customer Name"; Text[100])
        {
            CalcFormula = lookup(Customer.Name where("No." = field("Account No.")));
            Editable = false;
            FieldClass = FlowField;
        }
        field(70144613; "E-mail Sent"; Boolean)
        {
            DataClassification = CustomerContent;
            Editable = false;
        }
    }

    keys
    {
        key(Key1; "Entry No")
        {
        }
    }

    fieldgroups
    {
    }

    trigger OnInsert()
    begin
        Evaluate("Created By", UserId());
        "Created By Date Time" := CurrentDateTime();
    end;

    trigger OnModify()
    begin
        Evaluate("Last Modified By", UserId());
        "Last Modified Date Time" := CurrentDateTime();
    end;
}

