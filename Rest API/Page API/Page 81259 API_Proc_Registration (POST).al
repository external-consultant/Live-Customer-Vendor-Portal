page 81259 "API_Proc_Registration"  //"INT Web Portal - Login Mgmt"  --> Registration_gFnc
{
    // version WebPortal
    APIGroup = 'API';
    APIPublisher = 'ISPL';
    APIVersion = 'v2.0';
    Caption = 'apiWebPortalProcRegistration';
    DelayedInsert = true;
    EntityName = 'apiWebPortalProcRegistration';
    EntityCaption = 'apiWebPortalProcRegistration';
    EntitySetName = 'apiWebPortalProcRegistrations';    //Make Sure First Char in Small Letter and don't use any special char or space
    EntitySetCaption = 'apiWebPortalProcRegistrations';
    PageType = API;
    SourceTable = API_Post_Data;
    SourceTableTemporary = true;

    layout
    {
        area(Content)
        {
            group(General)
            {
                field(userID_iCod; Rec.UserID_iCod)
                {
                    ApplicationArea = All;
                }
                field(password_iCod; Rec.Password_iCod)
                {
                    ApplicationArea = All;
                }
                field(name_iCod; Rec.Name_iCod)
                {
                    ApplicationArea = All;
                }
                field(accountType_iTxt; Rec.AccountType_iTxt)
                {
                    ApplicationArea = All;
                }
                field(accountNo_iCod; Rec.AccountNo_iCod)
                {
                    ApplicationArea = All;
                }
                field(Result_gBln; Rec.Result_gBln)
                {
                    ApplicationArea = All;
                }
            }
        }
    }

    trigger OnInsertRecord(BelowxRec: Boolean): Boolean
    var
        Customer_lRec: Record Customer;
        InsertWebPortalLoginTable_lRec: Record "INT - Login Table";
        WebPortalLoginTable_lRec: Record "INT - Login Table";
        Vendor_lRec: Record Vendor;
        LoginType_lOpt: Option " ",Customer,Vendor;
    begin
        if Rec.UserID_iCod = '' then
            Error('User ID must not be blank');

        if Rec.Name_iCod = '' then
            Error('Name must not be blank');

        if Rec.Password_iCod = '' then
            Error('Password must not be blank');

        Evaluate(LoginType_lOpt, Rec.AccountType_iTxt);

        if LoginType_lOpt = LoginType_lOpt::" " then
            Error('Login Type must not be blank');

        if Rec.AccountNo_iCod = '' then
            Error('Account No. must not be blank');

        //SMTPMail_lCdu.CheckValidEmailAddresses(UserID_iCod);

        if LoginType_lOpt = LoginType_lOpt::Customer then begin
            Clear(Customer_lRec);
            if not Customer_lRec.Get(Rec.AccountNo_iCod) then
                Error('Customer %1 not find in Customer Table.', Rec.AccountNo_iCod);
        end else begin
            Clear(Vendor_lRec);
            if not Vendor_lRec.Get(Rec.AccountNo_iCod) then
                Error('Vendor %1 not find in Vendor Table.', Rec.AccountNo_iCod);
        end;

        WebPortalLoginTable_lRec.Reset();
        WebPortalLoginTable_lRec.SetRange("User ID (E-Mail)", Rec.UserID_iCod);
        if not WebPortalLoginTable_lRec.IsEmpty() then
            Error('Login Account with User ID %1 is already exists', Rec.UserID_iCod);

        InsertWebPortalLoginTable_lRec.Init();
        InsertWebPortalLoginTable_lRec.Validate("User ID (E-Mail)", Rec.UserID_iCod);
        InsertWebPortalLoginTable_lRec.Validate(Name, Rec.Name_iCod);
        InsertWebPortalLoginTable_lRec.Validate(Password, Rec.Password_iCod);
        InsertWebPortalLoginTable_lRec.Validate("Login Type", LoginType_lOpt);
        InsertWebPortalLoginTable_lRec.Validate("Account No.", Rec.AccountNo_iCod);
        InsertWebPortalLoginTable_lRec.Insert(true);

        Rec.Result_gBln := TRUE;
    end;

    trigger OnOpenPage()
    var
    // INTKeyValidationMgt: Codeunit "INT Key Validation Mgt";
    begin
        // Clear(INTKeyValidationMgt);
        // INTKeyValidationMgt.onOpenPageKeyValidation();
    end;

    var

        Result_gBln: Boolean;
}

