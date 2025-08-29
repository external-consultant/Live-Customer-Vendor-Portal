codeunit 81232 "INT Web Portal - Login Mgmt"
{
    // version WebPortal


    trigger OnRun()
    begin
        ForgetPassword_gFnc('nishit@intech-systems.com');
        RegeneratePassword_gFnc('nishit@intech-systems.com', '964F95E7818F46E1A77D', '123');
    end;

    procedure Registration_gFnc(UserID_iCod: Code[50]; Password_iCod: Text[20]; Name_iCod: Text[80]; AccountType_iTxt: Text[10]; AccountNo_iCod: Code[20]): Boolean
    var
        Customer_lRec: Record Customer;
        InsertWebPortalLoginTable_lRec: Record "INT - Login Table";
        WebPortalLoginTable_lRec: Record "INT - Login Table";
        Vendor_lRec: Record Vendor;
        //SMTPMail_lCdu: Codeunit "SMTP Mail";
        LoginType_lOpt: Option " ",Customer,Vendor;
    begin
        if UserID_iCod = '' then
            Error('User ID must not be blank');

        if Name_iCod = '' then
            Error('Name must not be blank');

        if Password_iCod = '' then
            Error('Password must not be blank');

        Evaluate(LoginType_lOpt, AccountType_iTxt);

        if LoginType_lOpt = LoginType_lOpt::" " then
            Error('Login Type must not be blank');

        if AccountNo_iCod = '' then
            Error('Account No. must not be blank');

        //SMTPMail_lCdu.CheckValidEmailAddresses(UserID_iCod);

        if LoginType_lOpt = LoginType_lOpt::Customer then begin
            Clear(Customer_lRec);
            if not Customer_lRec.Get(AccountNo_iCod) then
                Error('Customer %1 not find in Customer Table.', AccountNo_iCod);
        end else begin
            Clear(Vendor_lRec);
            if not Vendor_lRec.Get(AccountNo_iCod) then
                Error('Vendor %1 not find in Vendor Table.', AccountNo_iCod);
        end;

        WebPortalLoginTable_lRec.Reset();
        WebPortalLoginTable_lRec.SetRange("User ID (E-Mail)", UserID_iCod);
        if not WebPortalLoginTable_lRec.IsEmpty() then
            Error('Login Account with User ID %1 is already exists', UserID_iCod);

        InsertWebPortalLoginTable_lRec.Init();
        InsertWebPortalLoginTable_lRec.Validate("User ID (E-Mail)", UserID_iCod);
        InsertWebPortalLoginTable_lRec.Validate(Name, Name_iCod);
        InsertWebPortalLoginTable_lRec.Validate(Password, Password_iCod);
        InsertWebPortalLoginTable_lRec.Validate("Login Type", LoginType_lOpt);
        InsertWebPortalLoginTable_lRec.Validate("Account No.", AccountNo_iCod);
        InsertWebPortalLoginTable_lRec.Insert(true);

        exit(true);
    end;

    procedure Login_gFnc(UserID_iCod: Code[80]; Password_iCod: Text[20]; var LoginType_vTxt: Text[10]; var AccountNo_vCod: Code[20]; var AccountName_vTxt: Text[50]): Text[10]
    var
        Customer_lRec: Record Customer;
        WebPortalLoginHistory_lRec: Record "INT - Login History";
        WebPortalLoginTable_lRec: Record "INT - Login Table";
        SalespersonPurchaser_lRec: Record "Salesperson/Purchaser";
        Vendor_lRec: Record Vendor;
        INTKeyValidationMgt: Codeunit "IKV Mgt";
    begin
        Clear(INTKeyValidationMgt);
        INTKeyValidationMgt.onOpenPageKeyValidation();

        if UserID_iCod = '' then
            Error('User ID must not be blank');

        if Password_iCod = '' then
            Error('Password must not be blank');

        WebPortalLoginTable_lRec.Reset();
        WebPortalLoginTable_lRec.SetRange("User ID (E-Mail)", UserID_iCod);
        if not WebPortalLoginTable_lRec.FindFirst() then
            Error('User ID is incorrect');

        WebPortalLoginTable_lRec.Reset();
        WebPortalLoginTable_lRec.SetRange("User ID (E-Mail)", UserID_iCod);
        WebPortalLoginTable_lRec.SetRange(Password, Password_iCod);
        if WebPortalLoginTable_lRec.FindFirst() then begin
            LoginType_vTxt := CopyStr(Format(WebPortalLoginTable_lRec."Login Type"), 1, MaxStrLen(LoginType_vTxt));
            AccountNo_vCod := WebPortalLoginTable_lRec."Account No.";

            case true of
                WebPortalLoginTable_lRec."Login Type" = WebPortalLoginTable_lRec."Login Type"::Customer:
                    begin
                        Customer_lRec.Get(WebPortalLoginTable_lRec."Account No.");
                        AccountName_vTxt := COPYSTR(Customer_lRec.Name, 1, MaxStrLen(AccountName_vTxt));
                    end;
                else
                    if WebPortalLoginTable_lRec."Login Type" = WebPortalLoginTable_lRec."Login Type"::Vendor then begin
                        Vendor_lRec.Get(WebPortalLoginTable_lRec."Account No.");
                        AccountName_vTxt := COPYSTR(Vendor_lRec.Name, 1, MaxStrLen(AccountName_vTxt));
                    end else begin
                        SalespersonPurchaser_lRec.Get(WebPortalLoginTable_lRec."Account No.");
                        AccountName_vTxt := COPYSTR(SalespersonPurchaser_lRec.Name, 1, MaxStrLen(AccountName_vTxt));
                    end;
            end;

            WebPortalLoginHistory_lRec.Init();
            WebPortalLoginHistory_lRec."User ID" := UserID_iCod;
            WebPortalLoginHistory_lRec.Name := WebPortalLoginTable_lRec.Name;
            Evaluate(WebPortalLoginHistory_lRec."Login Type", LoginType_vTxt);
            WebPortalLoginHistory_lRec."Account No." := AccountNo_vCod;
            WebPortalLoginHistory_lRec."Login DateTime" := CurrentDateTime();
            WebPortalLoginHistory_lRec.Insert(true);
        end else
            Error('Password is incorrect');

        if WebPortalLoginTable_lRec."Temp Password" then
            exit('First')
        else
            exit('Second');
    end;

    procedure RegeneratePassword_gFnc(UserID_iCod: Code[50]; Password_iCod: Text[20]; NewPassword_iCod: Text[20]): Boolean
    var
        WebPortalLoginTable_lRec: Record "INT - Login Table";
    begin
        if UserID_iCod = '' then
            Error('User ID must not be blank');

        if Password_iCod = '' then
            Error('Password must not be blank');

        if NewPassword_iCod = '' then
            Error('New Password must not be blank');

        if Password_iCod = NewPassword_iCod then
            Error('Old Password and New Password cannot be same');

        WebPortalLoginTable_lRec.Reset();
        WebPortalLoginTable_lRec.SetRange("User ID (E-Mail)", UserID_iCod);
        if not WebPortalLoginTable_lRec.FindFirst() then
            Error('User ID is incorrect');

        WebPortalLoginTable_lRec.Reset();
        WebPortalLoginTable_lRec.SetRange("User ID (E-Mail)", UpperCase(UserID_iCod));
        WebPortalLoginTable_lRec.SetRange(Password, Password_iCod);
        if WebPortalLoginTable_lRec.FindFirst() then begin
            WebPortalLoginTable_lRec.Password := NewPassword_iCod;
            WebPortalLoginTable_lRec."Temp Password" := false;
            WebPortalLoginTable_lRec.Modify(true);
            exit(true);
        end else
            Error('Old Password is incorrect');
    end;

    procedure ForgetPassword_gFnc(UserID_iCod: Code[50]): Boolean
    var
        WebPortalLoginTable_lRec: Record "INT - Login Table";
    begin
        if UserID_iCod = '' then
            Error('User ID must not be blank');

        WebPortalLoginTable_lRec.Reset();
        WebPortalLoginTable_lRec.SetRange("User ID (E-Mail)", UpperCase(UserID_iCod));
        if WebPortalLoginTable_lRec.FindFirst() then begin
            //Send Email
            SendAccountDetails_gFnc(WebPortalLoginTable_lRec);
            exit(true);
        end else
            Error('Please Enter Correct Email ID');
    end;

    local procedure SendAccountDetails_gFnc(WebPortalLoginTable_iRec: Record "INT - Login Table")
    var
        CompanyInfo_lRec: Record "Company Information";
        Email: Codeunit Email;
        EmailMessage: Codeunit "Email Message";
        Text003LocalLbl: Label '<b>%1</b>', Comment = '%1=Field';
        Text001LocalLbl: Label 'Email ID: <b>%1</b>', Comment = '%1=Field';
        Text002LocalLbl: Label 'Password: <b>%1<b>', Comment = '%1=Field';
        BCC: List of [Text];
        CC: List of [Text];
        Recepients: List of [Text];
        BodyHTML_lTxt: Text;
        Subject_lTxt: Text;

    begin

        CompanyInfo_lRec.Get();

        Subject_lTxt := 'Web Portal Password Recovery';
        Recepients.Add(WebPortalLoginTable_iRec."User ID (E-Mail)");
        //SMTP_lCdu.CreateMessage('', SMTP_lRec."User ID", Recepients, Subject_lTxt, '');

        BodyHTML_lTxt += '<b>Dear Sir/Madam,</b>';
        BodyHTML_lTxt += '<BR/>';
        BodyHTML_lTxt += '<BR/>';

        BodyHTML_lTxt += StrSubstNo(Text001LocalLbl, LowerCase(WebPortalLoginTable_iRec."User ID (E-Mail)"));
        BodyHTML_lTxt += '<BR/>';
        BodyHTML_lTxt += '<BR/>';
        BodyHTML_lTxt += StrSubstNo(Text002LocalLbl, WebPortalLoginTable_iRec.Password);
        BodyHTML_lTxt += '<BR/>';
        BodyHTML_lTxt += '<BR/>';
        BodyHTML_lTxt += '<BR/>';
        BodyHTML_lTxt += '<BR/>';

        BodyHTML_lTxt += 'Thanks & Regards,';
        BodyHTML_lTxt += '<BR/>';
        BodyHTML_lTxt += StrSubstNo(Text003LocalLbl, CompanyInfo_lRec.Name);
        BodyHTML_lTxt += '<BR/>';
        BodyHTML_lTxt += '<BR/>';
        BodyHTML_lTxt += '<b>Note :</b> <i>This is system generated mail. Please do not reply on this Email Id.</i>';

        EmailMessage.Create(Recepients, 'D365 Business Central', BodyHTML_lTxt, true, CC, BCC);
        Clear(Email);
        if Email.Send(EmailMessage, Enum::"Email Scenario"::Default) then
            if GuiAllowed then
                Message('Email Sent Successfully');
    end;
}

