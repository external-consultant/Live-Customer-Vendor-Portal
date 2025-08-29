table 81230 "INT - Login Table"
{
    // version WebPortal

    fields
    {
        field(70144598; "User ID (E-Mail)"; Code[50])
        {
            DataClassification = CustomerContent;

            // trigger OnValidate()
            // var
            //     CheckEmail: Codeunit "SMTP Mail";
            // begin
            //     Clear(CheckEmail);
            //     //CheckEmail.CheckValidEmailAddresses("User ID (E-Mail)");
            // end;
        }
        field(70144599; Name; Text[80])
        {
            DataClassification = CustomerContent;
        }
        field(70144600; Password; Text[20])
        {
            DataClassification = CustomerContent;
            // ExtendedDatatype = Masked;
        }
        field(70144601; "Login Type"; Option)
        {
            DataClassification = CustomerContent;
            OptionCaption = ' ,Customer,Vendor';
            OptionMembers = " ",Customer,Vendor;
        }
        field(70144602; "Account No."; Code[20])
        {
            DataClassification = CustomerContent;
            TableRelation = if ("Login Type" = filter(Customer)) Customer
            else
            if ("Login Type" = filter(Vendor)) Vendor;

            trigger OnValidate()
            var
                myInt: Integer;
            begin

            end;
        }
        field(70144603; Blocked; Boolean)
        {
            DataClassification = CustomerContent;
            // TableRelation = "User Setup";

            trigger OnValidate()
            begin
                if Blocked then begin
                    Evaluate("Blocked By", UserId());
                    "Blocked Date Time" := CurrentDateTime();
                end else begin
                    "Blocked By" := '';
                    "Blocked Date Time" := 0DT;
                end;
            end;
        }
        field(70144604; "Blocked By"; Text[100])
        {
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(70144605; "Blocked Date Time"; DateTime)
        {
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(70144607; "Last Modified By"; Code[50])
        {
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(70144608; "Last Modified Date Time"; DateTime)
        {
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(70144609; "Created By"; Code[50])
        {
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(70144610; "Created By Date Time"; DateTime)
        {
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(70144611; "Temp Password"; Boolean)
        {
            DataClassification = CustomerContent;
            Editable = false;
        }
    }

    keys
    {
        key(Key1; "User ID (E-Mail)")
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
        //  Password := CopyStr(GetRandomString(), 1, 20);
        //   "Temp Password" := true;
    end;

    trigger OnModify()
    begin
        Evaluate("Last Modified By", UserId());
        "Last Modified Date Time" := CurrentDateTime();
    end;

    procedure SendLoginDetails()
    var
        CompanyInfo: Record "Company Information";
        WebPortalSetup: Record "INT Web Portal - Setup";
        // SMTPMailSetup: Record "SMTP Mail Setup";
        // SMTPMail: Codeunit "SMTP Mail";
        EmailMessage: Codeunit "Email Message";
        Email: Codeunit Email;
        Recepients: List of [Text];
        CC: List of [Text];
        BCC: List of [Text];
        BodyHTML_lTxt: text;
        Usersetup_lRec: Record "User Setup";
        Subject: Text;
        Name_lRec: Text[100];
        Customer_lRec: Record Customer;
        Vendor_lRec: Record Vendor;
    begin
        if Rec.Blocked then begin
            Error('User is blocked');
            exit;
        end;

        if not Confirm('Do you want to send credentials?', false) then
            exit;

        Clear(WebPortalSetup);
        WebPortalSetup.Get();

        TestField("User ID (E-Mail)");
        TestField("Account No.");
        TestField(Password);

        Recepients.Add("User ID (E-Mail)");
        Clear(CompanyInfo);

        CompanyInfo.Get();
        CompanyInfo.CalcFields(Picture);

        if Rec."Login Type" = Rec."Login Type"::Customer then begin

            WebPortalSetup.TestField("Customer Portal URL");

            Clear(Subject);
            Subject := CompanyInfo.Name + ':' + ' Customer Portal';

            Clear(Name_lRec);
            if Customer_lRec.Get("Account No.") then
                Name_lRec := Customer_lRec.Name;

            BodyHTML_lTxt += '<tr class="heading">';
            BodyHTML_lTxt += '<td>';
            BodyHTML_lTxt += 'Customer Portal URL';
            BodyHTML_lTxt += '</td>';

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
            BodyHTML_lTxt += '<td align="CENTER">' + Name + '</td>';
            BodyHTML_lTxt += '</tr>';

            BodyHTML_lTxt += '<th> Email </th>';
            BodyHTML_lTxt += '<td align="CENTER">' + "User ID (E-Mail)" + '</td>';
            BodyHTML_lTxt += '</tr>';

            BodyHTML_lTxt += '<tr>';
            BodyHTML_lTxt += '<th> Temporary Password </th>';
            BodyHTML_lTxt += '<td align="CENTER">' + Password + '</td>';
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

        if Rec."Login Type" = Rec."Login Type"::Vendor then begin

            WebPortalSetup.TestField("Vendor Portal URL");

            Clear(Subject);
            Subject := CompanyInfo.Name + ':' + ' Vendor Portal';

            Clear(Name_lRec);
            if Vendor_lRec.Get("Account No.") then
                Name_lRec := Vendor_lRec.Name;

            BodyHTML_lTxt += '<tr class="heading">';
            BodyHTML_lTxt += '<td>';
            BodyHTML_lTxt += 'Vendor Portal URL';
            BodyHTML_lTxt += '</td>';

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
            BodyHTML_lTxt += '<td align="CENTER">' + Name + '</td>';
            BodyHTML_lTxt += '</tr>';

            BodyHTML_lTxt += '<th> Email </th>';
            BodyHTML_lTxt += '<td align="CENTER">' + "User ID (E-Mail)" + '</td>';
            BodyHTML_lTxt += '</tr>';

            BodyHTML_lTxt += '<tr>';
            BodyHTML_lTxt += '<th> Temporary Password </th>';
            BodyHTML_lTxt += '<td align="CENTER">' + Password + '</td>';
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
    end;

    local procedure GetRandomString(): Text
    begin
        exit(DelChr(Format(CreateGuid()), '=', '{}-'));
    end;
}

