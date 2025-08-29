Table 81239 "Age Details"
{

    fields
    {
        field(1; Source; Option)
        {
            DataClassification = ToBeClassified;
            OptionMembers = "Vendor Age","Purchases","Customer Age","Sales";
        }
        field(2; "No."; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(3; Sequence; Integer)
        {
            DataClassification = ToBeClassified;
        }
        field(4; "Age by"; Text[10])
        {
            DataClassification = ToBeClassified;
        }
        field(5; Caption; Text[20])
        {
            DataClassification = ToBeClassified;
        }
        field(30; "Start Date"; Date)
        {
            DataClassification = ToBeClassified;
        }
        field(40; "End Date"; Date)
        {
            DataClassification = ToBeClassified;
        }
        field(50; Amount; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(60; CaptionYear; Integer)
        {
            DataClassification = ToBeClassified;
        }
    }

    keys
    {
        key(Key1; Source, "No.", "Age by", Sequence, Caption)
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }
}
