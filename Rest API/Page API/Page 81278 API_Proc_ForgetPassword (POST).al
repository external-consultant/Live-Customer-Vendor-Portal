page 81278 "API_Proc_ForgetPassword"  //"INT Web Portal - Login Mgmt"  --> ForgetPassword_gFnc
{
    // version WebPortal
    APIGroup = 'API';
    APIPublisher = 'ISPL';
    APIVersion = 'v2.0';
    Caption = 'apiWebPortalProcForgetPassword';
    DelayedInsert = true;
    EntityName = 'apiWebPortalProcForgetPassword';
    EntityCaption = 'apiWebPortalProcForgetPassword';
    EntitySetName = 'apiWebPortalProcForgetPasswords';    //Make Sure First Char in Small Letter and don't use any special char or space
    EntitySetCaption = 'apiWebPortalProcForgetPasswords';
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
                field(Result_lBln; Rec.Result_gBln)
                {
                    ApplicationArea = All;
                }
                field(accType_gTxt; AccType_gTxt)
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


        if not ((AccType_gTxt = 'Customer') or (AccType_gTxt = 'Vendor')) then
            Error('Access Denied');

        if AccType_gTxt = 'Customer' then begin
            WebPortalLoginTable_lRec.Reset();
            WebPortalLoginTable_lRec.SetRange("User ID (E-Mail)", UpperCase(Rec.UserID_iCod));
            WebPortalLoginTable_lRec.SetRange("Login Type", WebPortalLoginTable_lRec."Login Type"::Customer);
            if WebPortalLoginTable_lRec.FindFirst() then begin
                //Send Email
                SendAccountDetails_gFnc(WebPortalLoginTable_lRec);
                Rec.Result_gBln := true;
            end else
                Error('Access Denied');
        end else begin
            if AccType_gTxt = 'Vendor' then begin
                WebPortalLoginTable_lRec.Reset();
                WebPortalLoginTable_lRec.SetRange("User ID (E-Mail)", UpperCase(Rec.UserID_iCod));
                WebPortalLoginTable_lRec.SetRange("Login Type", WebPortalLoginTable_lRec."Login Type"::Vendor);
                if WebPortalLoginTable_lRec.FindFirst() then begin
                    //Send Email
                    SendAccountDetails_gFnc(WebPortalLoginTable_lRec);
                    Rec.Result_gBln := true;
                end else
                    Error('Access Denied');
            end;
        end;
    end;



    trigger OnOpenPage()
    var
        INTKeyValidationMgt: Codeunit "IKV Mgt";
    begin
        Clear(INTKeyValidationMgt);
        INTKeyValidationMgt.onOpenPageKeyValidation();
    end;

    local procedure SendAccountDetails_gFnc(WebPortalLoginTable_iRec: Record "INT - Login Table")
    var
        CompanyInfo: Record "Company Information";
        Email: Codeunit Email;
        EmailMessage: Codeunit "Email Message";
        Text003LocalLbl: Label '<b>%1</b>', Comment = '%1=Field';
        Text001LocalLbl: Label 'Email ID: <b>%1</b>', Comment = '%1=Field';
        Text002LocalLbl: Label 'Password: <b>%1<b>', Comment = '%1=Field';
        BCC: List of [Text];
        CC: List of [Text];
        Recepients: List of [Text];
        BodyHTML_lTxt: Text;
        Subject: Text;
        WebPortalSetup: Record "INT Web Portal - Setup";
        Name_lRec: Text[100];
        Customer_lRec: Record Customer;
        Vendor_lRec: Record Vendor;

    begin
        if WebPortalLoginTable_iRec.Blocked then begin
            Error('User is blocked');
            exit;
        end;

        Clear(WebPortalSetup);
        WebPortalSetup.Get();

        if WebPortalLoginTable_iRec."Account No." = '' then
            Error('Access Denied');

        if WebPortalLoginTable_iRec.Password = '' then
            Error('Access Denied');

        Recepients.Add(WebPortalLoginTable_iRec."User ID (E-Mail)");
        Clear(CompanyInfo);

        CompanyInfo.Get();
        CompanyInfo.CalcFields(Picture);

        if WebPortalLoginTable_iRec."Login Type" = WebPortalLoginTable_iRec."Login Type"::Customer then begin

            WebPortalSetup.TestField("Customer Portal URL");

            Clear(Subject);
            Subject := CompanyInfo.Name + ':' + ' Customer Portal';

            Clear(Name_lRec);
            if Customer_lRec.Get(WebPortalLoginTable_iRec."Account No.") then
                Name_lRec := Customer_lRec.Name;

            BodyHTML_lTxt := '';

            BodyHTML_lTxt += 'Dear Sir/Ma''am,';
            BodyHTML_lTxt += '<BR> Please find the credentials below';
            BodyHTML_lTxt += '<br><Br>';
            BodyHTML_lTxt += '<table Cellpadding = "0",cellspacing="0" border="4" style="width:100%;border-color:#000;">';
            BodyHTML_lTxt += '<tr>';
            BodyHTML_lTxt += '<th align="CENTER" colspan="2">' + Name_lRec + '</th>';
            BodyHTML_lTxt += '</tr>';
            BodyHTML_lTxt += '<tr>';

            BodyHTML_lTxt += '<tr>';
            BodyHTML_lTxt += '<th> URL </th>';
            BodyHTML_lTxt += '<td align="CENTER">' + WebPortalSetup."Customer Portal URL" + '</td>';
            BodyHTML_lTxt += '</tr>';

            BodyHTML_lTxt += '<th> Name </th>';
            BodyHTML_lTxt += '<td align="CENTER">' + WebPortalLoginTable_iRec.Name + '</td>';
            BodyHTML_lTxt += '</tr>';

            BodyHTML_lTxt += '<th> Email </th>';
            BodyHTML_lTxt += '<td align="CENTER">' + WebPortalLoginTable_iRec."User ID (E-Mail)" + '</td>';
            BodyHTML_lTxt += '</tr>';

            BodyHTML_lTxt += '<tr>';
            BodyHTML_lTxt += '<th> Temporary Password </th>';
            BodyHTML_lTxt += '<td align="CENTER">' + WebPortalLoginTable_iRec.Password + '</td>';
            BodyHTML_lTxt += '</tr>';
            BodyHTML_lTxt += '<tr>';

            BodyHTML_lTxt += '</table>';

            BodyHTML_lTxt += '<br/><br/>';

            BodyHTML_lTxt += '<tr> ******** Please change the Password. ******** </tr>';
            BodyHTML_lTxt += '<br>';
            BodyHTML_lTxt += '<br>';
            BodyHTML_lTxt += 'Thanks & Regards,';
            BodyHTML_lTxt += '<br/>';
        end;

        if WebPortalLoginTable_iRec."Login Type" = WebPortalLoginTable_iRec."Login Type"::Vendor then begin

            WebPortalSetup.TestField("Vendor Portal URL");

            Clear(Subject);
            Subject := CompanyInfo.Name + ':' + ' Vendor Portal';

            Clear(Name_lRec);
            if Vendor_lRec.Get(WebPortalLoginTable_iRec."Account No.") then
                Name_lRec := Vendor_lRec.Name;

            BodyHTML_lTxt := '';

            BodyHTML_lTxt += 'Dear Sir/Ma''am,';
            BodyHTML_lTxt += '<BR> Please find the credentials below';
            BodyHTML_lTxt += '<br><Br>';
            BodyHTML_lTxt += '<table Cellpadding = "0",cellspacing="0" border="4" style="width:100%;border-color:#000;">';
            BodyHTML_lTxt += '<tr>';
            BodyHTML_lTxt += '<th align="CENTER" colspan="2">' + Name_lRec + '</th>';
            BodyHTML_lTxt += '</tr>';
            BodyHTML_lTxt += '<tr>';

            BodyHTML_lTxt += '<tr>';
            BodyHTML_lTxt += '<th> URL </th>';
            BodyHTML_lTxt += '<td align="CENTER">' + WebPortalSetup."Vendor Portal URL" + '</td>';
            BodyHTML_lTxt += '</tr>';

            BodyHTML_lTxt += '<th> Name </th>';
            BodyHTML_lTxt += '<td align="CENTER">' + WebPortalLoginTable_iRec.Name + '</td>';
            BodyHTML_lTxt += '</tr>';

            BodyHTML_lTxt += '<th> Email </th>';
            BodyHTML_lTxt += '<td align="CENTER">' + WebPortalLoginTable_iRec."User ID (E-Mail)" + '</td>';
            BodyHTML_lTxt += '</tr>';

            BodyHTML_lTxt += '<tr>';
            BodyHTML_lTxt += '<th> Temporary Password </th>';
            BodyHTML_lTxt += '<td align="CENTER">' + WebPortalLoginTable_iRec.Password + '</td>';
            BodyHTML_lTxt += '</tr>';
            BodyHTML_lTxt += '<tr>';

            BodyHTML_lTxt += '</table>';

            BodyHTML_lTxt += '<br/><br/>';

            BodyHTML_lTxt += '<tr> ******** Please change the Password. ******** </tr>';
            BodyHTML_lTxt += '<br>';
            BodyHTML_lTxt += '<br>';
            BodyHTML_lTxt += 'Thanks & Regards,';
            BodyHTML_lTxt += '<br/>';
            
        end;

        if CompanyInfo."Contact Person" <> '' then
            BodyHTML_lTxt += CompanyInfo."Contact Person" + '<br>';

        if CompanyInfo.Name <> '' then
            BodyHTML_lTxt += CompanyInfo.Name + '<br>';

        if CompanyInfo.Address <> '' then
            BodyHTML_lTxt += CompanyInfo.Address + '<br>';

        if CompanyInfo."Address 2" <> '' then
            BodyHTML_lTxt += CompanyInfo."Address 2" + '<br>';

        if CompanyInfo.City <> '' then
            BodyHTML_lTxt += CompanyInfo.City + ',';

        if CompanyInfo."Post Code" <> '' then
            BodyHTML_lTxt += CompanyInfo."Post Code" + '<br>';

        if CompanyInfo."Phone No." <> '' then
            BodyHTML_lTxt += CompanyInfo."Phone No." + '<br>';

        if CompanyInfo."E-Mail" <> '' then
            BodyHTML_lTxt += CompanyInfo."E-Mail" + '<br></b>';

        BodyHTML_lTxt += '<b>Note :</b> <i>This is system generated mail. Please do not reply on this Email Id.</i>';

        EmailMessage.Create(Recepients, Subject, BodyHTML_lTxt, true, CC, BCC);
        Clear(Email);
        if Email.Send(EmailMessage, Enum::"Email Scenario"::Default) then
            if GuiAllowed then
                Message('Email Sent Successfully');

        // CompanyInfo_lRec.Get();

        // Subject_lTxt := 'Web Portal Password Recovery';
        // Recepients.Add(WebPortalLoginTable_iRec."User ID (E-Mail)");
        // // SMTP_lCdu.CreateMessage('', SMTP_lRec."User ID", Recepients, Subject_lTxt, '');

        // BodyHTML_lTxt += 'Dear Sir/Ma''am,';
        // BodyHTML_lTxt += '<BR> Please find the credentials below';
        // BodyHTML_lTxt += '<br><Br>';

        // BodyHTML_lTxt += '<table Cellpadding = "0",cellspacing="0" border="4" style="width:100%;border-color:#000;">';
        // BodyHTML_lTxt += '<tr>';
        // BodyHTML_lTxt += '<th align="CENTER" colspan="2">' + WebPortalLoginTable_iRec.Name + '</th>';
        // BodyHTML_lTxt += '</tr>';
        // BodyHTML_lTxt += '<tr>';

        // BodyHTML_lTxt += '<tr>';
        // BodyHTML_lTxt += '<th> Email </th>';
        // BodyHTML_lTxt += '<td align="CENTER">' + WebPortalLoginTable_iRec."User ID (E-Mail)" + '</td>';
        // BodyHTML_lTxt += '</tr>';

        // BodyHTML_lTxt += '<th> Name </th>';
        // BodyHTML_lTxt += '<td align="CENTER">' + WebPortalLoginTable_iRec.Name + '</td>';
        // BodyHTML_lTxt += '</tr>';

        // BodyHTML_lTxt += '<th> Email </th>';
        // BodyHTML_lTxt += '<td align="CENTER">' + "User ID (E-Mail)" + '</td>';
        // BodyHTML_lTxt += '</tr>';

        // BodyHTML_lTxt += '<tr>';
        // BodyHTML_lTxt += '<th> Temporary Password </th>';
        // BodyHTML_lTxt += '<td align="CENTER">' + Password + '</td>';
        // BodyHTML_lTxt += '</tr>';
        // BodyHTML_lTxt += '<tr>';

        // BodyHTML_lTxt += '</table>';

        // BodyHTML_lTxt += '<br/><br/>';


        // BodyHTML_lTxt += StrSubstNo(Text001LocalLbl, LowerCase(WebPortalLoginTable_iRec."User ID (E-Mail)"));
        // BodyHTML_lTxt += '<BR/>';
        // BodyHTML_lTxt += '<BR/>';
        // BodyHTML_lTxt += StrSubstNo(Text002LocalLbl, WebPortalLoginTable_iRec.Password);
        // BodyHTML_lTxt += '<BR/>';
        // BodyHTML_lTxt += '<BR/>';
        // BodyHTML_lTxt += '<BR/>';
        // BodyHTML_lTxt += '<BR/>';

        // BodyHTML_lTxt += 'Thanks & Regards,';
        // BodyHTML_lTxt += '<BR/>';
        // BodyHTML_lTxt += StrSubstNo(Text003LocalLbl, CompanyInfo_lRec.Name);
        // BodyHTML_lTxt += '<BR/>';
        // BodyHTML_lTxt += '<BR/>';
        // BodyHTML_lTxt += '<b>Note :</b> <i>This is system generated mail. Please do not reply on this Email Id.</i>';

        // EmailMessage.Create(Recepients, 'D365 Business Central', BodyHTML_lTxt, true, CC, BCC);
        // Clear(Email);
        // if Email.Send(EmailMessage, Enum::"Email Scenario"::Default) then
        //     if GuiAllowed then
        //         Message('Email Sent Successfully');
    end;

    var
        UserID_iCod: Code[50];
        Password_iCod: Text[20];
        NewPassword_iCod: Text[20];
        AccType_gTxt: Text[20];
        LoginType_Txt: Text[20];
}

