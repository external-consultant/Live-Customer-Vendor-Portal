table 81237 API_Post_Data
{
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "Entry No."; Integer)
        {
            AutoIncrement = true;
        }
        field(20; "Posting_Source"; Option)  //This field will indentify source of post API  //Registration
        {
            OptionMembers = "API_Oroc_Registration","API_Proc_Login","API_PictureUpload";
        }
        field(30; "UserID_iCod"; Code[50])
        {
        }
        field(40; "Password_iCod"; Text[50])
        {
        }
        field(50; "Name_iCod"; Text[50])
        {
        }
        field(60; "AccountType_iTxt"; Text[80])
        {
        }
        field(70; "AccountNo_iCod"; Text[80])
        {
        }
        field(80; "Result_gBln"; Boolean)
        {
        }

        // Login_gFun 
        field(90; LoginType_vTxt; Text[10])
        { }
        field(100; AccountNo_vCod; Code[20])
        { }
        field(110; AccountName_vTxt; Text[50])
        { }
        field(120; "Result_gTxt"; Text[20])
        {
        }
        
        // Login_gFun

        // RegeneratePassword_gFnc
        field(130; NewPassword_iCod; Text[20])
        {
        }
        // RegeneratePassword_gFnc

        // InsertCheckData_gFnc
        field(140; LoginType_iTxt; Text[50])
        {
        }
        field(150; AccNo_iCod; Code[20])
        {
        }
        field(160; PaymentType_iTxt; Text[50])
        {
        }
        field(170; CheckNo_iTxt; Text[30])
        {
        }
        field(180; CheckDate_iDte; Date)
        {
        }
        field(190; CheckIssueBy_iTxt; Text[50])
        {
        }
        field(200; CheckReceivedBy_iTxt; Text[50])
        {
        }
        field(210; BankName_iTxt; Text[50])
        {
        }
        field(220; BankBranchName_iTxt; Text[50])
        {
        }
        field(230; NEFT_RTGSRefNo_iTxt; Text[50])
        {
        }
        field(240; Amount_iDec; Decimal)
        {
        }
        // InsertCheckData_gFnc


        // CustomerStatistics_gFnc
        field(250; Balance_vDec; Decimal)
        { }
        field(260; OutstandingOrders_vDec; Decimal)
        { }
        field(270; OverdueAmount_vDec; Decimal)
        { }
        field(280; CreditLimits_vDec; Decimal)
        { }
        field(290; PaymentsCount_vInt; Integer)
        { }
        field(300; PostedInvoiceCount_vInt; Integer)
        { }
        field(310; SalesCrMemoHeaderCount_vInt; Integer)
        { }
        field(320; LastLoginDateTime_vDte; DateTime)
        { }
        // CustomerStatistics_gFnc

        // VendorStatistics_gFnc
        field(330; OverDueAmountCount_vInt; Integer)
        {
        }
        field(340; PendingPurchOrdCount_vInt; Integer)
        {
        }
        field(350; PostedPurchRcptCount_vInt; Integer)
        {
        }
        field(360; PostedDebitNotesCount_vInt; Integer)
        {
        }
        field(370; PastPurchInvCount_vInt; Integer)
        {
        }
        //

        // UpdateCheckData_gFnc
        field(380; EntryNo_iInt; Integer)
        {
        }
        // UpdateCheckData_gFnc

        // CusVendtInfo_gFnc
        field(390; LCYCode_vCod; Code[20])
        {
        }
        field(400; CompanyName_vTxt; Text[50])
        {
        }
        field(410; CustomerVenCode_iCod; Code[20])
        {
        }
        // CusVendtInfo_gFnc

        // CloseNotification_gFnc

        // CloseNotification_gFnc

        field(60010; "Source API Call"; Option)
        {
            OptionMembers = "API_Registration","API_UpdateProfile","API_PictureUpload";
            DataClassification = ToBeClassified;
        }

        field(99910; "Process Status"; Option)
        {
            DataClassification = ToBeClassified;
            Editable = false;
            OptionCaption = ' ,Success,Failed';
            OptionMembers = " ",Success,Failed;
        }
        field(99920; "Process DateTime"; DateTime)
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(99930; "Process User ID"; Code[50])
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(99940; "Process Error Log"; Text[250])
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
    }
    keys
    {
        key(PK; "Entry No.")
        {
            Clustered = true;
        }


    }
}
