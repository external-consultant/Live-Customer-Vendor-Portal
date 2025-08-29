report 81232 "INT Activate App"
{
    Caption = 'Activate App';
    ProcessingOnly = true;
    dataset
    {
    }

    requestpage
    {

        layout
        {
            area(Content)
            {
                group("Enter Activation Key")
                {
                    Caption = 'Enter Activation Key';
                    field("Key"; EnteredKey)
                    {
                        ApplicationArea = All;
                        Caption = 'Key';
                        ToolTip = 'Specifies the value of the Key field.';
                    }
                }
            }
        }

        actions
        {
        }
    }

    labels
    {
    }

    var
        EnteredKey: Code[250];

    trigger OnPreReport()
    var
        INTSetup: Record "INT Web Portal - Setup";
        INTKeyValidationMgt: Codeunit "IKV Mgt";
        EndDate: Date;
    begin
        if EnteredKey = '' then
            Error('Enter the Key first');
        Clear(INTKeyValidationMgt);
        EndDate := INTKeyValidationMgt.ValidateKey(EnteredKey);
        INTSetup.Get();
        INTSetup."Activation Key" := EnteredKey;
        INTSetup.Modify(true);
        Message('Your App has been Activated till Date %1.', EndDate);
    end;
}

