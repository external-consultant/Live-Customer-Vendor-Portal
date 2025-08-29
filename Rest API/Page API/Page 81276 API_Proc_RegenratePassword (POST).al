page 81276 "API_Proc_RegenratePassword"  //"INT Web Portal - Login Mgmt"  --> RegeneratePassword_gFnc
{
    // version WebPortal
    APIGroup = 'API';
    APIPublisher = 'ISPL';
    APIVersion = 'v2.0';
    Caption = 'apiWebPortalProcRegenratePassword';
    DelayedInsert = true;
    EntityName = 'apiWebPortalProcRegenratePassword';
    EntityCaption = 'apiWebPortalProcRegenratePassword';
    EntitySetName = 'apiWebPortalProcRegenratePasswords';    //Make Sure First Char in Small Letter and don't use any special char or space
    EntitySetCaption = 'apiWebPortalProcRegenratePasswords';
    PageType = API;
    SourceTable = API_Post_Data;
    SourceTableTemporary = true;

    layout
    {
        area(Content)
        {
            group(General)
            {
                field(uerIDiCod; Rec.UserID_iCod)
                {
                    ApplicationArea = All;
                }
                field(passwordiCod; Rec.Password_iCod)
                {
                    ApplicationArea = All;
                }
                field(newPasswordiCod; Rec.NewPassword_iCod)
                {
                    ApplicationArea = All;
                }
            }
        }
    }

    trigger OnInsertRecord(BelowxRec: Boolean): Boolean
    var
        WebPortalLoginTable_lRec: Record "INT - Login Table";
    begin
        if Rec.UserID_iCod = '' then
            Error('User ID must not be blank');

        if Rec.Password_iCod = '' then
            Error('Password must not be blank');

        if Rec.NewPassword_iCod = '' then
            Error('New Password must not be blank');

        if Rec.Password_iCod = Rec.NewPassword_iCod then
            Error('Old Password and New Password cannot be same');

        WebPortalLoginTable_lRec.Reset();
        WebPortalLoginTable_lRec.SetRange("User ID (E-Mail)", UpperCase(Rec.UserID_iCod));
        if not WebPortalLoginTable_lRec.FindFirst() then
            Error('User ID is incorrect');

        WebPortalLoginTable_lRec.Reset();
        WebPortalLoginTable_lRec.SetRange("User ID (E-Mail)", UpperCase(Rec.UserID_iCod));
        WebPortalLoginTable_lRec.SetRange(Password, Rec.Password_iCod);
        if WebPortalLoginTable_lRec.FindFirst() then begin
            WebPortalLoginTable_lRec.Password := Rec.NewPassword_iCod;
            WebPortalLoginTable_lRec."Temp Password" := false;
            WebPortalLoginTable_lRec.Modify(true);

            Result_lBln := true;

        end else
            Error('Old Password is incorrect');
    end;

    trigger OnOpenPage()
    var
        INTKeyValidationMgt: Codeunit "IKV Mgt";
    begin
        Clear(INTKeyValidationMgt);
        INTKeyValidationMgt.onOpenPageKeyValidation();
    end;

    var
        UserID_iCod: Code[50];
        Password_iCod: Text[20];
        NewPassword_iCod: Text[20];
        Result_lBln: Boolean;
}

