table 81234 "INT Web Portal - Setup"
{
    // version WebPortal   

    fields
    {
        field(70144598; "Primary Key"; Integer)
        {
            DataClassification = CustomerContent;
        }
        field(70144599; "Email as CC for Cust/Vend"; Boolean)
        {
            Caption = 'Email as CC for Customer/Vendor';
            DataClassification = CustomerContent;
        }
        field(70144600; "Activation Key"; Code[250])
        {
            DataClassification = CustomerContent;
            Editable = false;

            trigger OnValidate()
            var
                INTKeyValidationMgt: Codeunit "IKV Mgt";
                EndDate: Date;
            begin
                if "Activation Key" <> '' then begin
                    Clear(INTKeyValidationMgt);
                    // EndDate := INTKeyValidationMgt.ValidateKey("Activation Key");
                    Message('Your App has been Activated, Last Date is %1', EndDate);
                end;
            end;
        }
        field(70144601; "Business Portal URL"; Text[250])
        {
            DataClassification = CustomerContent;
        }
        field(70144602; "Customer Portal URL"; Text[250])
        {
            DataClassification = ToBeClassified;
        }
        field(70144603; "Vendor Portal URL"; Text[250])
        {
            DataClassification = ToBeClassified;
        }
    }

    keys
    {
        key(Key1; "Primary Key")
        {
        }
    }

    fieldgroups
    {
    }
}

