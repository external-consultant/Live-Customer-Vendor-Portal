page 81265 "API_Proc_Login"  //"INT Web Portal - Login Mgmt"  --> Login_gFnc
{
    // version WebPortal
    APIGroup = 'API';
    APIPublisher = 'ISPL';
    APIVersion = 'v2.0';
    Caption = 'apiWebPortalProcLogin';
    DelayedInsert = true;
    EntityName = 'apiWebPortalProcLogin';
    EntityCaption = 'apiWebPortalProcLogin';
    EntitySetName = 'apiWebPortalProcLogins';    //Make Sure First Char in Small Letter and don't use any special char or space
    EntitySetCaption = 'apiWebPortalProcLogins';
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
                field(Password_iCod; Rec.Password_iCod)
                {
                    Visible = false;
                }
                field(loginTypevTxt; Rec.LoginType_vTxt)
                {
                    ApplicationArea = All;
                }
                field(accountNovCod; Rec.AccountNo_vCod)
                {
                    ApplicationArea = All;
                }
                field(accountNamevTxt; Rec.AccountName_vTxt)
                {
                    ApplicationArea = All;
                }
                field(Result_gTxt; Rec.Result_gTxt)
                {
                    ApplicationArea = All;
                }

            }
        }
    }

    trigger OnInsertRecord(BelowxRec: Boolean): Boolean
    var
        Customer_lRec: Record Customer;
        WebPortalLoginHistory_lRec: Record "INT - Login History";
        WebPortalLoginTable_lRec: Record "INT - Login Table";
        SalespersonPurchaser_lRec: Record "Salesperson/Purchaser";
        Vendor_lRec: Record Vendor;
        INTKeyValidationMgt: Codeunit "IKV Mgt";
    begin

        // WebPortalLoginTable_lRec.Reset();
        // WebPortalLoginTable_lRec.SetRange("Login Type", WebPortalLoginTable_lRec."Login Type"::Vendor);
        // if WebPortalLoginTable_lRec.FindSet() then
        //     repeat
        //         WebPortalLoginTable_lRec.Delete();
        //     until WebPortalLoginTable_lRec.Next() = 0;

        // Clear(INTKeyValidationMgt);
        // INTKeyValidationMgt.onOpenPageKeyValidation();

        if Rec.UserID_iCod = '' then
            Error('User ID must not be blank');

        if Rec.Password_iCod = '' then
            Error('Password must not be blank');

        WebPortalLoginTable_lRec.Reset();
        if Not WebPortalLoginTable_lRec.Get(UpperCase(Rec.UserID_iCod)) then
            Error('User ID is incorrect');

        WebPortalLoginTable_lRec.Reset();
        WebPortalLoginTable_lRec.Get(UpperCase(Rec.UserID_iCod));
        IF WebPortalLoginTable_lRec.Blocked then
            Error('You are not allowed to access the Portal.');

        If Rec.Password_iCod <> WebPortalLoginTable_lRec.Password then
            Error('Password is incorrect');

        if WebPortalLoginTable_lRec.Get(UpperCase(Rec.UserID_iCod)) then begin
            Rec.LoginType_vTxt := CopyStr(Format(WebPortalLoginTable_lRec."Login Type"), 1, MaxStrLen(Rec.LoginType_vTxt));
            Rec.AccountNo_vCod := WebPortalLoginTable_lRec."Account No.";

            // if Rec.LoginType_iTxt = 'Vendor' then begin
            //     Clear(Vendor_lRec);
            //     Vendor_lRec.get(WebPortalLoginTable_lRec."Account No.");
            //     Rec.AccountName_vTxt := COPYSTR(Customer_lRec.Name, 1, MaxStrLen(Rec.AccountName_vTxt));
            // end;

            // if Rec.LoginType_iTxt = 'Customer' then begin
            //     Clear(Customer_lRec);
            //     Customer_lRec.get(WebPortalLoginTable_lRec."Account No.");
            //     Rec.AccountName_vTxt := COPYSTR(Customer_lRec.Name, 1, MaxStrLen(Rec.AccountName_vTxt));
            // end;

            // case true of

            if WebPortalLoginTable_lRec."Login Type" = WebPortalLoginTable_lRec."Login Type"::Customer then begin
                Customer_lRec.Get(WebPortalLoginTable_lRec."Account No.");
                Rec.AccountName_vTxt := COPYSTR(Customer_lRec.Name, 1, MaxStrLen(Rec.AccountName_vTxt));

                // Check
                Clear(CduVendorAgeLoad);
                CduVendorAgeLoad.ProcessCustomer_gFnc(WebPortalLoginTable_lRec."Account No.");

                Clear(CduVendorAgeLoad);
                CduVendorAgeLoad.ProcessSales_gFnc(WebPortalLoginTable_lRec."Account No.");
                // Check

            end
            else
                if WebPortalLoginTable_lRec."Login Type" = WebPortalLoginTable_lRec."Login Type"::Vendor then begin
                    Vendor_lRec.Get(WebPortalLoginTable_lRec."Account No.");
                    Rec.AccountName_vTxt := COPYSTR(Vendor_lRec.Name, 1, MaxStrLen(Rec.AccountName_vTxt));

                    // Check
                    Clear(CduVendorAgeLoad);
                    CduVendorAgeLoad.ProcessVendor_gFnc(WebPortalLoginTable_lRec."Account No.");

                    Clear(CduVendorAgeLoad);
                    CduVendorAgeLoad.ProcessPurchase_gFnc(WebPortalLoginTable_lRec."Account No.");
                    // Check

                end else begin
                    SalespersonPurchaser_lRec.Get(WebPortalLoginTable_lRec."Account No.");
                    Rec.AccountName_vTxt := COPYSTR(SalespersonPurchaser_lRec.Name, 1, MaxStrLen(Rec.AccountName_vTxt));
                end;

            WebPortalLoginHistory_lRec.Init();
            WebPortalLoginHistory_lRec."User ID" := Rec.UserID_iCod;
            WebPortalLoginHistory_lRec.Name := WebPortalLoginTable_lRec.Name;
            Evaluate(WebPortalLoginHistory_lRec."Login Type", Rec.LoginType_vTxt);
            WebPortalLoginHistory_lRec."Account No." := Rec.AccountNo_vCod;
            WebPortalLoginHistory_lRec."Login DateTime" := CurrentDateTime();
            WebPortalLoginHistory_lRec.Insert(true);

        end else
            Error('Password is incorrect');

        if WebPortalLoginTable_lRec."Temp Password" then
            Rec.Result_gTxt := 'First'
        else
            Rec.Result_gTxt := 'Last';
            
    end;

    // trigger OnOpenPage()
    // var
    //     INTKeyValidationMgt: Codeunit "IKV Mgt";
    // begin
    //     Clear(INTKeyValidationMgt);
    //     INTKeyValidationMgt.onOpenPageKeyValidation();
    // end;

    var
        CduVendorAgeLoad: Codeunit "CV Age Load";
}

