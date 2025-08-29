table 81235 "INT - Sales Order Line"
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
        field(70144599; "Customer No."; Code[20])
        {
            DataClassification = CustomerContent;
        }
        field(70144600; "Customer Name"; Text[50])
        {
            DataClassification = CustomerContent;
        }
        field(70144601; "Item No."; Code[20])
        {
            DataClassification = CustomerContent;
        }
        field(70144602; Description; Text[50])
        {
            DataClassification = CustomerContent;
        }
        field(70144603; "Description 2"; Text[50])
        {
            DataClassification = CustomerContent;
        }
        field(70144604; "Requested Date"; Date)
        {
            DataClassification = CustomerContent;
        }
        field(70144605; "Requested Receipt Date"; Date)
        {
            DataClassification = CustomerContent;
        }
        field(70144606; Quantity; Decimal)
        {
            BlankZero = true;
            DataClassification = CustomerContent;
        }
        field(70144607; Remarks; Text[250])
        {
            DataClassification = CustomerContent;
        }
        field(70144608; "Base Unit of Measure"; Code[10])
        {
            DataClassification = CustomerContent;
        }
        field(70144609; "Created By"; Code[50])
        {
            DataClassification = CustomerContent;
        }
        field(70144610; "Created DateTime"; DateTime)
        {
            DataClassification = CustomerContent;
        }
        field(70144611; "Modified By"; Code[50])
        {
            DataClassification = CustomerContent;
        }
        field(70144612; "Modified DateTime"; DateTime)
        {
            DataClassification = CustomerContent;
        }
        field(70144613; "Order Created By"; Option)
        {
            DataClassification = CustomerContent;
            OptionCaption = ' ,Customer,Vendor,SalesPerson';
            OptionMembers = " ",Customer,Vendor,SalesPerson;
        }
        field(70144614; "Sales Person Name"; Text[50])
        {
            DataClassification = CustomerContent;
        }
        field(70144615; "Sales Person Code"; Code[20])
        {
            DataClassification = CustomerContent;
        }
        field(70144616; "Created Sales Order No."; Code[20])
        {
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(70144617; "Created Sales Order Line No."; Integer)
        {
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(70144618; "Order Converted"; Boolean)
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
        Evaluate("Created By", UserId());
        "Created DateTime" := CurrentDateTime();
    end;

    trigger OnModify()
    begin
        Evaluate("Modified By", UserId());
        "Modified DateTime" := CurrentDateTime();
    end;
}

