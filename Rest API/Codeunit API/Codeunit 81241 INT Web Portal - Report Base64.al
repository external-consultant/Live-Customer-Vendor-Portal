codeunit 81241 "INT Web Portal - Report Base64"
{
    // version WebPortal

    trigger OnRun()
    begin
        //MESSAGE(PrintPostedSalesInvoice_gFnc('STINV-1314-00011'));
        //PrintPostedSalesInvoice_gFnc('R/1617/0268');
    end;

    var
        WebPortalSetup_gRec: Record "INT Web Portal - Setup";

    procedure PrintPostedSalesInvoice_gFnc(DocumentNo_iCod: Code[20]; var Base64_vTxt: Text; var FileName_vTxt: Text): Boolean
    var
        CompanyInfo: Record "Company Information";
        Customer: Record Customer;
        SalesInvoiceHeader_lRec: Record "Sales Invoice Header";
        Email: Codeunit Email;
        EmailMessage: Codeunit "Email Message";

        BCC: List of [Text];
        CC: List of [Text];
        Recepients: List of [Text];

        BodyHTML_lTxt: Text;
        XMLParameter: Text;
    begin
        SalesInvoiceHeader_lRec.Reset();
        SalesInvoiceHeader_lRec.SetRange("No.", DocumentNo_iCod);
        if not SalesInvoiceHeader_lRec.FindFirst() then
            Error('Sales Invoice doesnot exists with Document No. %1', DocumentNo_iCod);

        RecRef.GetTable(SalesInvoiceHeader_lRec);

        if not (WebportalReportSetup_gRec.Get(WebportalReportSetup_gRec."Report Name"::"Posted Sales Invoice")) then
            Error('Access Denied');

        WebportalReportSetup_gRec.Reset();
        WebportalReportSetup_gRec.Get(WebportalReportSetup_gRec."Report Name"::"Posted Sales Invoice");
        WebportalReportSetup_gRec.TestField("Report ID");

        ClearGlobVar;
        Rpt_TempBlob.CreateOutStream(Rpt_OutStream);
        Report.SaveAs(WebportalReportSetup_gRec."Report ID", '', REPORTFORMAT::Pdf, Rpt_OutStream, RecRef);
        Rpt_TempBlob.CreateInStream(Rpt_InStream);
        Base64_vTxt := Base64Convert.ToBase64(Rpt_InStream);
        FileName_vTxt := FileMgt_gCdu.StripNotsupportChrInFileName('PostedSalesInvoice_' + DocumentNo_iCod) + '.pdf';

        exit(true);
    end;

    procedure PrintPostedSalesCreditNote_gFnc(DocumentNo_iCod: Code[20]; var Base64_vTxt: Text; var FileName_vTxt: Text): Boolean
    var
        CompanyInfo: Record "Company Information";
        Customer: Record Customer;
        SalesCrMemoHeader_lRec: Record "Sales Cr.Memo Header";
        Email: Codeunit Email;
        EmailMessage: Codeunit "Email Message";

        BCC: List of [Text];
        CC: List of [Text];
        Recepients: List of [Text];

        BodyHTML_lTxt: Text;
        XMLParameter: Text;
    begin
        SalesCrMemoHeader_lRec.Reset();
        SalesCrMemoHeader_lRec.SetRange("No.", DocumentNo_iCod);
        if not SalesCrMemoHeader_lRec.FindFirst() then
            Error('Sales Cr. Memo doesnot exists with Document No. %1', DocumentNo_iCod);

        RecRef.GetTable(SalesCrMemoHeader_lRec);

        if not (WebportalReportSetup_gRec.Get(WebportalReportSetup_gRec."Report Name"::"Posted Sales Credit Notes")) then
            Error('Access Denied');

        WebportalReportSetup_gRec.Reset();

        WebportalReportSetup_gRec.Get(WebportalReportSetup_gRec."Report Name"::"Posted Sales Credit Notes");
        WebportalReportSetup_gRec.TestField("Report ID");

        ClearGlobVar;
        Rpt_TempBlob.CreateOutStream(Rpt_OutStream);
        Report.SaveAs(WebportalReportSetup_gRec."Report ID", '', REPORTFORMAT::Pdf, Rpt_OutStream, RecRef);
        Rpt_TempBlob.CreateInStream(Rpt_InStream);
        Base64_vTxt := Base64Convert.ToBase64(Rpt_InStream);
        FileName_vTxt := FileMgt_gCdu.StripNotsupportChrInFileName('PostedSalesCreditNote_' + DocumentNo_iCod) + '.pdf';

        exit(true);
    end;

    procedure PrintSalesOrder_gFnc(DocumentNo_iCod: Code[20]; var Base64_vTxt: Text; var FileName_vTxt: Text): Boolean
    var
        CompanyInfo: Record "Company Information";
        Customer: Record Customer;
        SalesHeader_lRec: Record "Sales Header";
        Email: Codeunit Email;
        EmailMessage: Codeunit "Email Message";

        BCC: List of [Text];
        CC: List of [Text];
        Recepients: List of [Text];

        BodyHTML_lTxt: Text;
        XMLParameter: Text;
    begin
        SalesHeader_lRec.Reset();
        SalesHeader_lRec.SetRange("Document Type", SalesHeader_lRec."Document Type"::Order);
        SalesHeader_lRec.SetRange("No.", DocumentNo_iCod);
        if not SalesHeader_lRec.FindFirst() then
            Error('Sales Order doesnot exists with Document No. %1', DocumentNo_iCod);

        RecRef.GetTable(SalesHeader_lRec);

        if not (WebportalReportSetup_gRec.Get(WebportalReportSetup_gRec."Report Name"::"Sales Order")) then
            Error('Access Denied');

        WebportalReportSetup_gRec.Reset();

        WebportalReportSetup_gRec.Get(WebportalReportSetup_gRec."Report Name"::"Sales Order");
        WebportalReportSetup_gRec.TestField("Report ID");

        ClearGlobVar;
        Rpt_TempBlob.CreateOutStream(Rpt_OutStream);
        Report.SaveAs(WebportalReportSetup_gRec."Report ID", '', REPORTFORMAT::Pdf, Rpt_OutStream, RecRef);
        Rpt_TempBlob.CreateInStream(Rpt_InStream);
        Base64_vTxt := Base64Convert.ToBase64(Rpt_InStream);
        FileName_vTxt := FileMgt_gCdu.StripNotsupportChrInFileName('SalesOrder_' + DocumentNo_iCod) + '.pdf';

        exit(true);
    end;

    procedure PrintPostedPurchDebitNote_gFnc(DocumentNo_iCod: Code[20]; var Base64_vTxt: Text; var FileName_vTxt: Text): Boolean
    var
        CompanyInfo: Record "Company Information";
        PurchCrMemoHdr_lRec: Record "Purch. Cr. Memo Hdr.";
        Vendor: Record Vendor;
        Email: Codeunit Email;
        EmailMessage: Codeunit "Email Message";


        BCC: List of [Text];
        CC: List of [Text];
        Recepients: List of [Text];

        BodyHTML_lTxt: Text;
        XMLParameter: Text;

    begin
        PurchCrMemoHdr_lRec.Reset();
        PurchCrMemoHdr_lRec.SetRange("No.", DocumentNo_iCod);
        if not PurchCrMemoHdr_lRec.FindFirst() then
            Error('Purchase Debit Note doesnot exists with Document No. %1', DocumentNo_iCod);

        RecRef.GetTable(PurchCrMemoHdr_lRec);

        if not (WebportalReportSetup_gRec.Get(WebportalReportSetup_gRec."Report Name"::"Posted Purchase Debit Note")) then
            Error('Access Denied');

        WebportalReportSetup_gRec.Reset();

        WebportalReportSetup_gRec.Get(WebportalReportSetup_gRec."Report Name"::"Posted Purchase Debit Note");
        WebportalReportSetup_gRec.TestField("Report ID");

        ClearGlobVar;
        Rpt_TempBlob.CreateOutStream(Rpt_OutStream);
        Report.SaveAs(WebportalReportSetup_gRec."Report ID", '', REPORTFORMAT::Pdf, Rpt_OutStream, RecRef);
        Rpt_TempBlob.CreateInStream(Rpt_InStream);
        Base64_vTxt := Base64Convert.ToBase64(Rpt_InStream);
        FileName_vTxt := FileMgt_gCdu.StripNotsupportChrInFileName('PurchaseCreditMemo_' + DocumentNo_iCod) + '.pdf';

        exit(true);
    end;

    procedure PrintPurchaseOrder_gFnc(DocumentNo_iCod: Code[20]; var Base64_vTxt: Text; var FileName_vTxt: Text): Boolean
    var
        CompanyInfo: Record "Company Information";
        PurchaseHeader_lRec: Record "Purchase Header";
        Vendor: Record Vendor;
        Email: Codeunit Email;
        EmailMessage: Codeunit "Email Message";

        BCC: List of [Text];
        CC: List of [Text];
        Recepients: List of [Text];

        BodyHTML_lTxt: Text;
        XMLParameter: Text;

    begin
        PurchaseHeader_lRec.Reset();
        PurchaseHeader_lRec.SetRange("Document Type", PurchaseHeader_lRec."Document Type"::Order);
        PurchaseHeader_lRec.SetRange("No.", DocumentNo_iCod);
        if not PurchaseHeader_lRec.FindFirst() then
            Error('Purchase Order doesnot exists with Document No. %1', DocumentNo_iCod);


        Recepients.Add(UserID);

        RecRef.GetTable(PurchaseHeader_lRec);

        if not (WebportalReportSetup_gRec.Get(WebportalReportSetup_gRec."Report Name"::"Purchase Order")) then
            Error('Access Denied');

        WebportalReportSetup_gRec.Reset();

        WebportalReportSetup_gRec.Get(WebportalReportSetup_gRec."Report Name"::"Purchase Order");
        WebportalReportSetup_gRec.TestField("Report ID");

        ClearGlobVar;
        Rpt_TempBlob.CreateOutStream(Rpt_OutStream);
        Report.SaveAs(WebportalReportSetup_gRec."Report ID", '', REPORTFORMAT::Pdf, Rpt_OutStream, RecRef);
        Rpt_TempBlob.CreateInStream(Rpt_InStream);
        Base64_vTxt := Base64Convert.ToBase64(Rpt_InStream);
        FileName_vTxt := FileMgt_gCdu.StripNotsupportChrInFileName('PurchaseOrder_' + DocumentNo_iCod) + '.pdf';

        exit(true);
    end;

    procedure PrintCustomerStatement_gFnc(CustomerNo_iCod: Code[20]; StateDate_iDate: Date; EndDate_iDate: Date; var Base64_vTxt: Text; var FileName_vTxt: Text): Boolean
    var
        CompanyInfo: Record "Company Information";
        Customer_lRec: Record Customer;
        CustomerLedgerReport: Report "INT Customer Ledger";
        Email: Codeunit Email;
        EmailMessage: Codeunit "Email Message";

        ConvertedEndDate: Date;
        ConvertedStartDate: Date;

        DD: Integer;
        MM: Integer;
        YYYY: Integer;
        BCC: List of [Text];
        CC: List of [Text];
        Recepients: List of [Text];

        BodyHTML_lTxt: Text;
        XMLParameter: Text;

    begin
        if StateDate_iDate = 0D then
            Error('Please select the Start Date');

        if EndDate_iDate = 0D then
            Error('Please select the End Date');

        // ConvertedStartDate := 0D;
        // MM := 0;
        // DD := 0;
        // YYYY := 0;
        // Evaluate(MM, CopyStr(Format(StateDate_iDate), 1, 2));
        // Evaluate(DD, CopyStr(Format(StateDate_iDate), 4, 2));
        // Evaluate(YYYY, CopyStr(Format(StateDate_iDate), 7, 4));

        // ConvertedStartDate := DMY2Date(DD, MM, YYYY);

        // ConvertedEndDate := 0D;
        // MM := 0;
        // DD := 0;
        // YYYY := 0;
        // Evaluate(MM, CopyStr(Format(EndDate_iDate), 1, 2));
        // Evaluate(DD, CopyStr(Format(EndDate_iDate), 4, 2));
        // Evaluate(YYYY, CopyStr(Format(EndDate_iDate), 7, 4));

        // ConvertedEndDate := DMY2Date(DD, MM, YYYY);

        // Customer_lRec.Reset();
        // Customer_lRec.SetRange("No.", CustomerNo_iCod);
        // Customer_lRec.SetFilter("Date Filter", '%1..%2', ConvertedStartDate, ConvertedEndDate);
        // if not Customer_lRec.FindFirst() then
        //     Error('Statement from Date %1 to %2 doesnot exists.', ConvertedStartDate, ConvertedEndDate);

        XMLParameter := StrSubstNo('<?xml version="1.0" standalone="yes"?><ReportParameters name="Standard Statement" id="1316"><Options><Field name="StartDate">%1</Field><Field name="EndDate">%2</Field><Field name="StatementStyle">0</Field><Field name="PrintEntriesDue">false</Field><Field name="PrintAllHavingEntry">false</Field><Field name="PrintAllHavingBal">true</Field><Field name="PrintReversedEntries">false</Field><Field name="PrintUnappliedEntries">false</Field><Field name="IncludeAgingBand">false</Field><Field name="PeriodLength">1M+CM</Field><Field name="DateChoice">0</Field><Field name="LogInteraction">true</Field><Field name="SupportedOutputMethod">0</Field><Field name="ChosenOutputMethod">0</Field><Field name="PrintIfEmailIsMissing">false</Field></Options><DataItems><DataItem name="Customer">VERSION(1) SORTING(Field1)</DataItem><DataItem name="Integer">VERSION(1) SORTING(Field1)</DataItem><DataItem name="CurrencyLoop">VERSION(1) SORTING(Field1)</DataItem><DataItem name="CustLedgEntryHdr">VERSION(1) SORTING(Field1)</DataItem><DataItem name="DtldCustLedgEntries">VERSION(1) SORTING(Field9,Field4,Field3,Field10)</DataItem><DataItem name="CustLedgEntryFooter">VERSION(1) SORTING(Field1)</DataItem><DataItem name="OverdueVisible">VERSION(1) SORTING(Field1)</DataItem><DataItem name="CustLedgEntry2">VERSION(1) SORTING(Field3,Field36,Field43,Field37,Field11)</DataItem><DataItem name="OverdueEntryFooder">VERSION(1) SORTING(Field1)</DataItem><DataItem name="AgingBandVisible">VERSION(1) SORTING(Field1)</DataItem><DataItem name="AgingCustLedgEntry">VERSION(1) SORTING(Field3,Field36,Field43,Field37,Field11)</DataItem><DataItem name="AgingBandLoop">VERSION(1) SORTING(Field1)</DataItem><DataItem name="LetterText">VERSION(1) SORTING(Field1)</DataItem></DataItems></ReportParameters>', FORMAT(StateDate_iDate,0,'<Year4>-<Month,2>-<Day,2>'), FORMAT(EndDate_iDate,0,'<Year4>-<Month,2>-<Day,2>'));

        Customer_lRec.Reset();
        Customer_lRec.SetRange("No.", CustomerNo_iCod);
        Customer_lRec.SetFilter("Date Filter", '%1..%2', StateDate_iDate, EndDate_iDate);
        if not Customer_lRec.FindFirst() then
            Error('Statement from Date %1 to %2 doesnot exists.', StateDate_iDate, EndDate_iDate);

        RecRef.GetTable(Customer_lRec);

        if not (WebportalReportSetup_gRec.Get(WebportalReportSetup_gRec."Report Name"::"Customer Statement")) then
            Error('Access Denied');

        WebportalReportSetup_gRec.Reset();

        WebportalReportSetup_gRec.Get(WebportalReportSetup_gRec."Report Name"::"Customer Statement");
        WebportalReportSetup_gRec.TestField("Report ID");

        ClearGlobVar;
        Rpt_TempBlob.CreateOutStream(Rpt_OutStream);
        Report.SaveAs(WebportalReportSetup_gRec."Report ID", XMLParameter, REPORTFORMAT::Pdf, Rpt_OutStream, RecRef);
        Rpt_TempBlob.CreateInStream(Rpt_InStream);
        Base64_vTxt := Base64Convert.ToBase64(Rpt_InStream);

        // ClearGlobVar;
        // Rpt_TempBlob.CreateOutStream(Rpt_OutStream);
        // Clear(CustomerLedgerReport);
        // CustomerLedgerReport.SetTableView(Customer_lRec);
        // CustomerLedgerReport.SetParameter(ConvertedStartDate, ConvertedEndDate);
        // CustomerLedgerReport.SaveAs('', REPORTFORMAT::Pdf, Rpt_OutStream);
        // Rpt_TempBlob.CreateInStream(Rpt_InStream);
        // Base64_vTxt := Base64Convert.ToBase64(Rpt_InStream);

        FileName_vTxt := FileMgt_gCdu.StripNotsupportChrInFileName('CustomerStatement' + CustomerNo_iCod) + '.pdf';

        exit(true);
    end;

    procedure PrintCustomerStatementEXCEL_gFnc(CustomerNo_iCod: Code[20]; StateDate_iDate: Date; EndDate_iDate: Date; var Base64_vTxt: Text; var FileName_vTxt: Text): Boolean
    var
        CompanyInfo: Record "Company Information";
        Customer_lRec: Record Customer;
        CustomerLedgerReport: Report "INT Customer Ledger";
        Email: Codeunit Email;
        EmailMessage: Codeunit "Email Message";

        ConvertedEndDate: Date;
        ConvertedStartDate: Date;

        DD: Integer;
        MM: Integer;
        YYYY: Integer;
        BCC: List of [Text];
        CC: List of [Text];
        Recepients: List of [Text];

        BodyHTML_lTxt: Text;
        XMLParameter: Text;
    begin
        if StateDate_iDate = 0D then
            Error('Please select the Start Date');

        if EndDate_iDate = 0D then
            Error('Please select the End Date');

        // ConvertedStartDate := 0D;
        // MM := 0;
        // DD := 0;
        // YYYY := 0;
        // Evaluate(MM, CopyStr(Format(StateDate_iDate), 1, 2));
        // Evaluate(DD, CopyStr(Format(StateDate_iDate), 4, 2));
        // Evaluate(YYYY, CopyStr(Format(StateDate_iDate), 7, 4));

        // ConvertedStartDate := DMY2Date(DD, MM, YYYY);

        // ConvertedEndDate := 0D;
        // MM := 0;
        // DD := 0;
        // YYYY := 0;
        // Evaluate(MM, CopyStr(Format(EndDate_iDate), 1, 2));
        // Evaluate(DD, CopyStr(Format(EndDate_iDate), 4, 2));
        // Evaluate(YYYY, CopyStr(Format(EndDate_iDate), 7, 4));

        // ConvertedEndDate := DMY2Date(DD, MM, YYYY);

        // Customer_lRec.Reset();
        // Customer_lRec.SetRange("No.", CustomerNo_iCod);
        // Customer_lRec.SetFilter("Date Filter", '%1..%2', ConvertedStartDate, ConvertedEndDate);
        // if not Customer_lRec.FindFirst() then
        //     Error('Statement from Date %1 to %2 doesnot exists.', ConvertedStartDate, ConvertedEndDate);

        Customer_lRec.Reset();
        Customer_lRec.SetRange("No.", CustomerNo_iCod);
        Customer_lRec.SetFilter("Date Filter", '%1..%2', StateDate_iDate, EndDate_iDate);
        if not Customer_lRec.FindFirst() then
            Error('Statement from Date %1 to %2 doesnot exists.', StateDate_iDate, EndDate_iDate);

        RecRef.GetTable(Customer_lRec);

        if not (WebportalReportSetup_gRec.Get(WebportalReportSetup_gRec."Report Name"::"Customer Statement")) then
            Error('Access Denied');

        WebportalReportSetup_gRec.Reset();

        WebportalReportSetup_gRec.Get(WebportalReportSetup_gRec."Report Name"::"Customer Statement");
        WebportalReportSetup_gRec.TestField("Report ID");

        ClearGlobVar;
        Rpt_TempBlob.CreateOutStream(Rpt_OutStream);
        Report.SaveAs(WebportalReportSetup_gRec."Report ID", '', REPORTFORMAT::Excel, Rpt_OutStream, RecRef);
        Rpt_TempBlob.CreateInStream(Rpt_InStream);
        Base64_vTxt := Base64Convert.ToBase64(Rpt_InStream);

        // ClearGlobVar;
        // Rpt_TempBlob.CreateOutStream(Rpt_OutStream);
        // Clear(CustomerLedgerReport);
        // CustomerLedgerReport.SetTableView(Customer_lRec);
        // CustomerLedgerReport.SetParameter(ConvertedStartDate, ConvertedEndDate);
        // CustomerLedgerReport.SaveAs('', REPORTFORMAT::Excel, Rpt_OutStream);
        // Rpt_TempBlob.CreateInStream(Rpt_InStream);
        // Base64_vTxt := Base64Convert.ToBase64(Rpt_InStream);

        FileName_vTxt := FileMgt_gCdu.StripNotsupportChrInFileName('CustomerStatement' + CustomerNo_iCod) + '.xlsx';

        exit(true);
    end;

    procedure PrintCustomerStatementD365_gFnc(CustomerNo_iCod: Code[20]; StateDate_iDate: Date; EndDate_iDate: Date; var Base64_vTxt: Text; var FileName_vTxt: Text): Boolean
    var
        CompanyInfo: Record "Company Information";
        Customer_lRec: Record Customer;
        CustomerLedgerReport: Report "INT Customer Ledger";
        Email: Codeunit Email;
        EmailMessage: Codeunit "Email Message";

        BCC: List of [Text];
        CC: List of [Text];
        Recepients: List of [Text];

        BodyHTML_lTxt: Text;
        XMLParameter: Text;
    begin
        if StateDate_iDate = 0D then
            Error('Please select the Start Date');

        if EndDate_iDate = 0D then
            Error('Please select the End Date');

        Customer_lRec.Reset();
        Customer_lRec.SetRange("No.", CustomerNo_iCod);
        Customer_lRec.SetFilter("Date Filter", '%1..%2', StateDate_iDate, EndDate_iDate);
        if not Customer_lRec.FindFirst() then
            Error('Statement from Date %1 to %2 doesnot exists.', StateDate_iDate, EndDate_iDate);

        RecRef.GetTable(Customer_lRec);

        WebportalReportSetup_gRec.Get(WebportalReportSetup_gRec."Report Name"::"Customer Statement");
        WebportalReportSetup_gRec.TestField("Report ID");

        ClearGlobVar;
        Rpt_TempBlob.CreateOutStream(Rpt_OutStream);
        Report.SaveAs(WebportalReportSetup_gRec."Report ID", '', REPORTFORMAT::Pdf, Rpt_OutStream, RecRef);
        Rpt_TempBlob.CreateInStream(Rpt_InStream);
        Base64_vTxt := Base64Convert.ToBase64(Rpt_InStream);

        // ClearGlobVar;
        // Rpt_TempBlob.CreateOutStream(Rpt_OutStream);
        // Clear(CustomerLedgerReport);
        // CustomerLedgerReport.SetTableView(Customer_lRec);
        // CustomerLedgerReport.SetParameter(StateDate_iDate, EndDate_iDate);
        // CustomerLedgerReport.SaveAs('', ReportFormat::Pdf, Rpt_OutStream);
        // Rpt_TempBlob.CreateInStream(Rpt_InStream);
        // Base64_vTxt := Base64Convert.ToBase64(Rpt_InStream);

        FileName_vTxt := FileMgt_gCdu.StripNotsupportChrInFileName('CustomerStatement' + CustomerNo_iCod) + '.pdf';
        exit(true);
    end;

    procedure PrintCustomerStatementEXCELD365_gFnc(CustomerNo_iCod: Code[20]; StateDate_iDate: Date; EndDate_iDate: Date; var Base64_vTxt: Text; var FileName_vTxt: Text): Boolean
    var
        CompanyInfo: Record "Company Information";
        Customer_lRec: Record Customer;
        CustomerLedgerReport: Report "INT Customer Ledger";
        Email: Codeunit Email;
        EmailMessage: Codeunit "Email Message";


        BCC: List of [Text];
        CC: List of [Text];
        Recepients: List of [Text];

        BodyHTML_lTxt: Text;
        XMLParameter: Text;
    begin
        if StateDate_iDate = 0D then
            Error('Please select the Start Date');

        if EndDate_iDate = 0D then
            Error('Please select the End Date');

        Customer_lRec.Reset();
        Customer_lRec.SetRange("No.", CustomerNo_iCod);
        Customer_lRec.SetFilter("Date Filter", '%1..%2', StateDate_iDate, EndDate_iDate);
        if not Customer_lRec.FindFirst() then
            Error('Statement from Date %1 to %2 doesnot exists.', StateDate_iDate, EndDate_iDate);

        ClearGlobVar;
        Rpt_TempBlob.CreateOutStream(Rpt_OutStream);
        Clear(CustomerLedgerReport);
        CustomerLedgerReport.SetTableView(Customer_lRec);
        CustomerLedgerReport.SetParameter(StateDate_iDate, EndDate_iDate);
        CustomerLedgerReport.SaveAs(XMLParameter, ReportFormat::Excel, Rpt_OutStream);
        Rpt_TempBlob.CreateInStream(Rpt_InStream);
        Base64_vTxt := Base64Convert.ToBase64(Rpt_InStream);

        FileName_vTxt := FileMgt_gCdu.StripNotsupportChrInFileName('CustomerStatement' + CustomerNo_iCod) + '.xlsx';
        exit(true);
    end;

    procedure PrintVendorStatement_gFnc(VendorNo_iCod: Code[20]; StateDate_iDate: Date; EndDate_iDate: Date; var Base64_vTxt: Text; var FileName_vTxt: Text): Boolean
    var
        CompanyInfo: Record "Company Information";
        Vendor_lRec: Record Vendor;
        VendorLedgerReport: Report "INT Vendor Ledger";
        Email: Codeunit Email;
        EmailMessage: Codeunit "Email Message";

        ConvertedEndDate: Date;
        ConvertedStartDate: Date;

        DD: Integer;
        MM: Integer;
        YYYY: Integer;
        BCC: List of [Text];
        CC: List of [Text];
        Recepients: List of [Text];

        BodyHTML_lTxt: Text;
        XMLParameter: Text;
    begin
        if StateDate_iDate = 0D then
            Error('Please select the Start Date');

        if EndDate_iDate = 0D then
            Error('Please select the End Date');

        // ConvertedStartDate := 0D;
        // MM := 0;
        // DD := 0;
        // YYYY := 0;
        // Evaluate(MM, CopyStr(Format(StateDate_iDate), 1, 2));
        // Evaluate(DD, CopyStr(Format(StateDate_iDate), 4, 2));
        // Evaluate(YYYY, CopyStr(Format(StateDate_iDate), 7, 4));

        // ConvertedStartDate := DMY2Date(DD, MM, YYYY);

        // ConvertedEndDate := 0D;
        // MM := 0;
        // DD := 0;
        // YYYY := 0;

        // Evaluate(MM, CopyStr(Format(EndDate_iDate), 1, 2));
        // Evaluate(DD, CopyStr(Format(EndDate_iDate), 4, 2));
        // Evaluate(YYYY, CopyStr(Format(EndDate_iDate), 7, 4));

        // ConvertedEndDate := DMY2Date(DD, MM, YYYY);

        Vendor_lRec.Reset();
        Vendor_lRec.SetRange("No.", VendorNo_iCod);
        Vendor_lRec.SetFilter("Date Filter", '%1..%2', StateDate_iDate, EndDate_iDate);
        if not Vendor_lRec.FindFirst() then
            Error('Statement from Date %1 to %2 doesnot exists.', StateDate_iDate, EndDate_iDate);

        // Vendor_lRec.Reset();
        // Vendor_lRec.SetRange("No.", VendorNo_iCod);
        // Vendor_lRec.SetFilter("Date Filter", '%1..%2', ConvertedStartDate, ConvertedEndDate);
        // if not Vendor_lRec.FindFirst() then
        //     Error('Statement from Date %1 to %2 doesnot exists.', ConvertedStartDate, ConvertedEndDate);

        RecRef.GetTable(Vendor_lRec);

        if not (WebportalReportSetup_gRec.Get(WebportalReportSetup_gRec."Report Name"::"Vendor Statement")) then
            Error('Access Denied');

        WebportalReportSetup_gRec.Reset();

        WebportalReportSetup_gRec.Get(WebportalReportSetup_gRec."Report Name"::"Vendor Statement");
        WebportalReportSetup_gRec.TestField("Report ID");

        ClearGlobVar;
        Rpt_TempBlob.CreateOutStream(Rpt_OutStream);
        Report.SaveAs(WebportalReportSetup_gRec."Report ID", '', REPORTFORMAT::Pdf, Rpt_OutStream, RecRef);
        Rpt_TempBlob.CreateInStream(Rpt_InStream);
        Base64_vTxt := Base64Convert.ToBase64(Rpt_InStream);

        // ClearGlobVar;
        // Rpt_TempBlob.CreateOutStream(Rpt_OutStream);
        // VendorLedgerReport.SetTableView(Vendor_lRec);
        // VendorLedgerReport.SetParameter(ConvertedStartDate, ConvertedEndDate);
        // VendorLedgerReport.SaveAs('', ReportFormat::Pdf, Rpt_OutStream);
        // Rpt_TempBlob.CreateInStream(Rpt_InStream);
        // Base64_vTxt := Base64Convert.ToBase64(Rpt_InStream);

        FileName_vTxt := FileMgt_gCdu.StripNotsupportChrInFileName('VendorStatement' + VendorNo_iCod) + '.pdf';
        exit(true);
    end;

    procedure PrintVendorStatementEXCEL_gFnc(VendorNo_iCod: Code[20]; StateDate_iDate: Date; EndDate_iDate: Date; var Base64_vTxt: Text; var FileName_vTxt: Text): Boolean
    var
        CompanyInfo: Record "Company Information";
        Vendor_lRec: Record Vendor;
        VendorLedgerReport: Report "INT Vendor Ledger";
        Email: Codeunit Email;
        EmailMessage: Codeunit "Email Message";

        ConvertedEndDate: Date;
        ConvertedStartDate: Date;

        DD: Integer;
        MM: Integer;
        YYYY: Integer;
        BCC: List of [Text];
        CC: List of [Text];
        Recepients: List of [Text];
        BodyHTML_lTxt: Text;
        XMLParameter: Text;
    begin
        if StateDate_iDate = 0D then
            Error('Please select the Start Date');

        if EndDate_iDate = 0D then
            Error('Please select the End Date');

        // ConvertedStartDate := 0D;
        // MM := 0;
        // DD := 0;
        // YYYY := 0;
        // Evaluate(MM, CopyStr(Format(StateDate_iDate), 1, 2));
        // Evaluate(DD, CopyStr(Format(StateDate_iDate), 4, 2));
        // Evaluate(YYYY, CopyStr(Format(StateDate_iDate), 7, 4));

        // ConvertedStartDate := DMY2Date(DD, MM, YYYY);

        // ConvertedEndDate := 0D;
        // MM := 0;
        // DD := 0;
        // YYYY := 0;
        // Evaluate(MM, CopyStr(Format(EndDate_iDate), 1, 2));
        // Evaluate(DD, CopyStr(Format(EndDate_iDate), 4, 2));
        // Evaluate(YYYY, CopyStr(Format(EndDate_iDate), 7, 4));

        // ConvertedEndDate := DMY2Date(DD, MM, YYYY);

        Vendor_lRec.Reset();
        Vendor_lRec.SetRange("No.", VendorNo_iCod);
        Vendor_lRec.SetFilter("Date Filter", '%1..%2', StateDate_iDate, EndDate_iDate);
        if not Vendor_lRec.FindFirst() then
            Error('Statement from Date %1 to %2 doesnot exists.', StateDate_iDate, EndDate_iDate);

        RecRef.GetTable(Vendor_lRec);

        if not (WebportalReportSetup_gRec.Get(WebportalReportSetup_gRec."Report Name"::"Vendor Statement")) then
            Error('Access Denied');

        WebportalReportSetup_gRec.Reset();

        WebportalReportSetup_gRec.Get(WebportalReportSetup_gRec."Report Name"::"Vendor Statement");
        WebportalReportSetup_gRec.TestField("Report ID");

        ClearGlobVar;
        Rpt_TempBlob.CreateOutStream(Rpt_OutStream);
        Report.SaveAs(WebportalReportSetup_gRec."Report ID", '', REPORTFORMAT::Excel, Rpt_OutStream, RecRef);
        Rpt_TempBlob.CreateInStream(Rpt_InStream);
        Base64_vTxt := Base64Convert.ToBase64(Rpt_InStream);

        // ClearGlobVar;
        // Rpt_TempBlob.CreateOutStream(Rpt_OutStream);
        // Clear(VendorLedgerReport);
        // VendorLedgerReport.SetTableView(Vendor_lRec);
        // VendorLedgerReport.SetParameter(ConvertedStartDate, ConvertedEndDate);
        // VendorLedgerReport.SaveAs('', ReportFormat::Excel, Rpt_OutStream);
        // Rpt_TempBlob.CreateInStream(Rpt_InStream);
        // Base64_vTxt := Base64Convert.ToBase64(Rpt_InStream);

        FileName_vTxt := FileMgt_gCdu.StripNotsupportChrInFileName('VendorStatement' + VendorNo_iCod) + '.xlsx';
        exit(true);
    end;

    procedure PrintVendorStatementD365_gFnc(VendorNo_iCod: Code[20]; StateDate_iTxt: Date; EndDate_iTxt: Date; var Base64_vTxt: Text; var FileName_vTxt: Text): Boolean
    var
        CompanyInfo: Record "Company Information";
        Vendor_lRec: Record Vendor;
        VendorLedgerReport: Report "INT Vendor Ledger";
        Email: Codeunit Email;
        EmailMessage: Codeunit "Email Message";

        BCC: List of [Text];
        CC: List of [Text];
        Recepients: List of [Text];

        BodyHTML_lTxt: Text;
        XMLParameter: Text;
    begin
        if StateDate_iTxt = 0D then
            Error('Please select the Start Date');

        if EndDate_iTxt = 0D then
            Error('Please select the End Date');

        Vendor_lRec.Reset();
        Vendor_lRec.SetRange("No.", VendorNo_iCod);
        Vendor_lRec.SetFilter("Date Filter", '%1..%2', StateDate_iTxt, EndDate_iTxt);
        if not Vendor_lRec.FindFirst() then
            Error('Statement from Date %1 to %2 doesnot exists.', StateDate_iTxt, EndDate_iTxt);

        RecRef.GetTable(Vendor_lRec);

        WebportalReportSetup_gRec.Get(WebportalReportSetup_gRec."Report Name"::"Vendor Statement");
        WebportalReportSetup_gRec.TestField("Report ID");

        ClearGlobVar;
        Rpt_TempBlob.CreateOutStream(Rpt_OutStream);
        Report.SaveAs(WebportalReportSetup_gRec."Report ID", '', REPORTFORMAT::Pdf, Rpt_OutStream, RecRef);
        Rpt_TempBlob.CreateInStream(Rpt_InStream);
        Base64_vTxt := Base64Convert.ToBase64(Rpt_InStream);

        // ClearGlobVar;
        // Rpt_TempBlob.CreateOutStream(Rpt_OutStream);
        // Clear(VendorLedgerReport);
        // VendorLedgerReport.SetTableView(Vendor_lRec);
        // VendorLedgerReport.SetParameter(StateDate_iTxt, EndDate_iTxt);
        // VendorLedgerReport.SaveAs('', ReportFormat::Pdf, Rpt_OutStream);

        // Rpt_TempBlob.CreateInStream(Rpt_InStream);
        // Base64_vTxt := Base64Convert.ToBase64(Rpt_InStream);

        FileName_vTxt := FileMgt_gCdu.StripNotsupportChrInFileName('VendorStatement' + VendorNo_iCod) + '.pdf';
        exit(true);
    end;

    procedure PrintVendorStatementEXCELD365_gFnc(VendorNo_iCod: Code[20]; StateDate_iTxt: Date; EndDate_iTxt: Date; var Base64_vTxt: Text; var FileName_vTxt: Text): Boolean
    var
        CompanyInfo: Record "Company Information";
        Vendor_lRec: Record Vendor;
        VendorLedgerReport: Report "INT Vendor Ledger";
        Email: Codeunit Email;
        EmailMessage: Codeunit "Email Message";


        BCC: List of [Text];
        CC: List of [Text];
        Recepients: List of [Text];

        BodyHTML_lTxt: Text;
        XMLParameter: Text;
    begin
        if StateDate_iTxt = 0D then
            Error('Please select the Start Date');

        if EndDate_iTxt = 0D then
            Error('Please select the End Date');

        Vendor_lRec.Reset();
        Vendor_lRec.SetRange("No.", VendorNo_iCod);
        Vendor_lRec.SetFilter("Date Filter", '%1..%2', StateDate_iTxt, EndDate_iTxt);
        if not Vendor_lRec.FindFirst() then
            Error('Statement from Date %1 to %2 doesnot exists.', StateDate_iTxt, EndDate_iTxt);

        ClearGlobVar;
        Rpt_TempBlob.CreateOutStream(Rpt_OutStream);
        Clear(VendorLedgerReport);
        VendorLedgerReport.SetTableView(Vendor_lRec);
        VendorLedgerReport.SetParameter(StateDate_iTxt, EndDate_iTxt);
        VendorLedgerReport.SaveAs('', ReportFormat::Excel, Rpt_OutStream);
        Rpt_TempBlob.CreateInStream(Rpt_InStream);
        Base64_vTxt := Base64Convert.ToBase64(Rpt_InStream);
        FileName_vTxt := FileMgt_gCdu.StripNotsupportChrInFileName('VendorStatement' + VendorNo_iCod) + '.xlsx';
        exit(true);
    end;

    procedure PrintCustomerPayments_gFnc(DocumentNo_iCod: Code[20]; var Base64_vTxt: Text; var FileName_vTxt: Text): Boolean
    var
        CompanyInfo: Record "Company Information";
        CustLedgEntry: Record "Cust. Ledger Entry";
        Customer: Record Customer;
        Email: Codeunit Email;
        EmailMessage: Codeunit "Email Message";

        BCC: List of [Text];
        CC: List of [Text];
        Recepients: List of [Text];

        BodyHTML_lTxt: Text;
        XMLParameter: Text;

    begin
        CustLedgEntry.Reset();
        CustLedgEntry.SetRange("Document No.", DocumentNo_iCod);
        if not CustLedgEntry.FindFirst() then
            Error('There is no Ledger Entry with Document No. %1', DocumentNo_iCod);

        Clear(Customer);
        Customer.Get(CustLedgEntry."Customer No.");
        CustLedgEntry.CalcFields(Amount);

        RecRef.GetTable(CustLedgEntry);

        if not (WebportalReportSetup_gRec.Get(WebportalReportSetup_gRec."Report Name"::"Customer Payments")) then
            Error('Access Denied');

        WebportalReportSetup_gRec.Reset();

        WebportalReportSetup_gRec.Get(WebportalReportSetup_gRec."Report Name"::"Customer Payments");
        WebportalReportSetup_gRec.TestField("Report ID");

        ClearGlobVar;
        Rpt_TempBlob.CreateOutStream(Rpt_OutStream);
        Report.SaveAs(WebportalReportSetup_gRec."Report ID", '', ReportFormat::Pdf, Rpt_OutStream, RecRef);
        Rpt_TempBlob.CreateInStream(Rpt_InStream);
        Base64_vTxt := Base64Convert.ToBase64(Rpt_InStream);
        FileName_vTxt := FileMgt_gCdu.StripNotsupportChrInFileName('CustomerPaymentReceipt' + DocumentNo_iCod) + '.pdf';
        exit(true);
    end;

    procedure PrintVendorPayments_gFnc(DocumentNo_iCod: Code[20]; var Base64_vTxt: Text; var FileName_vTxt: Text): Boolean
    var
        CompanyInfo: Record "Company Information";
        Vendor: Record Vendor;
        VendLedgEntry: Record "Vendor Ledger Entry";
        Email: Codeunit Email;
        EmailMessage: Codeunit "Email Message";


        BCC: List of [Text];
        CC: List of [Text];
        Recepients: List of [Text];

        BodyHTML_lTxt: Text;
        XMLParameter: Text;
    begin
        VendLedgEntry.Reset();
        VendLedgEntry.SetRange("Document No.", DocumentNo_iCod);
        if not VendLedgEntry.FindFirst() then
            Error('There is no Ledger Entry with Document No. %1', DocumentNo_iCod);

        Clear(Vendor);
        Vendor.Get(VendLedgEntry."Vendor No.");

        // //XMLParameter := Report.RunRequestPage(411);
        // Clear(CompanyInfo);
        // CompanyInfo.Get();

        // Recepients.Add(UserID);
        // //SMTPMail.CreateMessage('Intech Systems Pvt. Ltd.', SMTPMailsetup."User ID", Recepients, 'D365 Business Central', '');

        Clear(CompanyInfo);
        CompanyInfo.Get();
        CompanyInfo.CalcFields(Picture);
        VendLedgEntry.CalcFields(Amount);

        RecRef.GetTable(VendLedgEntry);

        if not (WebportalReportSetup_gRec.Get(WebportalReportSetup_gRec."Report Name"::"Vendor Payments")) then
            Error('Access Denied');

        WebportalReportSetup_gRec.Reset();

        WebportalReportSetup_gRec.Get(WebportalReportSetup_gRec."Report Name"::"Vendor Payments");
        WebportalReportSetup_gRec.TestField("Report ID");

        ClearGlobVar;
        Rpt_TempBlob.CreateOutStream(Rpt_OutStream);
        Report.SaveAs(WebportalReportSetup_gRec."Report ID", '', ReportFormat::Pdf, Rpt_OutStream, RecRef);
        Rpt_TempBlob.CreateInStream(Rpt_InStream);
        Base64_vTxt := Base64Convert.ToBase64(Rpt_InStream);
        FileName_vTxt := FileMgt_gCdu.StripNotsupportChrInFileName('PaymentReceipt_' + DocumentNo_iCod) + '.pdf';
        exit(true);
    end;

    procedure PrintPendingSalesInvoice_gFnc(No_iCod: Code[20]; var Base64_vTxt: Text; var FileName_vTxt: Text): Boolean
    var
        CompanyInfo: Record "Company Information";
        Customer: Record Customer;
        SalesHeader_lRec: Record "Sales Header";
        Email: Codeunit Email;
        EmailMessage: Codeunit "Email Message";

        BCC: List of [Text];
        CC: List of [Text];
        Recepients: List of [Text];

        BodyHTML_lTxt: Text;
        XMLParameter: Text;
    begin
        SalesHeader_lRec.Reset();
        SalesHeader_lRec.SetRange("No.", No_iCod);
        if not SalesHeader_lRec.FindFirst() then
            Error('Sales Invoice does not exists with No. %1', No_iCod);

        Clear(Customer);
        Customer.Get(SalesHeader_lRec."Sell-to Customer No.");

        //XMLParameter := Report.RunRequestPage(202);

        Clear(CompanyInfo);
        CompanyInfo.Get();

        RecRef.GetTable(SalesHeader_lRec);

        if not (WebportalReportSetup_gRec.Get(WebportalReportSetup_gRec."Report Name"::"Pending Sales Invoice")) then
            Error('Access Denied');

        WebportalReportSetup_gRec.Reset();

        WebportalReportSetup_gRec.Get(WebportalReportSetup_gRec."Report Name"::"Pending Sales Invoice");
        WebportalReportSetup_gRec.TestField("Report ID");

        ClearGlobVar;
        Rpt_TempBlob.CreateOutStream(Rpt_OutStream);
        Report.SaveAs(WebportalReportSetup_gRec."Report ID", '', ReportFormat::Pdf, Rpt_OutStream, RecRef);
        Rpt_TempBlob.CreateInStream(Rpt_InStream);
        Base64_vTxt := Base64Convert.ToBase64(Rpt_InStream);
        FileName_vTxt := FileMgt_gCdu.StripNotsupportChrInFileName('SalesInvoice_' + No_iCod) + '.pdf';
        exit(true);

    end;

    procedure PrintPostedPurchInvoice_gFnc(DocumentNo_iCod: Code[20]; var Base64_vTxt: Text; var FileName_vTxt: Text): Boolean
    var
        CompanyInfo: Record "Company Information";
        PurchInvHeader_lRec: Record "Purch. Inv. Header";
        Vendor: Record Vendor;
        Email: Codeunit Email;
        EmailMessage: Codeunit "Email Message";

        BCC: List of [Text];

        CC: List of [Text];
        Recepients: List of [Text];

        BodyHTML_lTxt: Text;
        XMLParameter: Text;
    begin
        PurchInvHeader_lRec.Reset();
        PurchInvHeader_lRec.SetRange("No.", DocumentNo_iCod);
        if not PurchInvHeader_lRec.FindFirst() then
            Error('Purchase Invoice doesnot exists with Document No. %1', DocumentNo_iCod);

        Clear(Vendor);
        Vendor.Get(PurchInvHeader_lRec."Buy-from Vendor No.");

        //XMLParameter := Report.RunRequestPage(406);
        Recepients.Add(UserID);
        // SMTPMail.CreateMessage('Intech Systems Pvt. Ltd.', SMTPMailsetup."User ID", Recepients, 'D365 Business Central', '');

        Clear(CompanyInfo);
        CompanyInfo.Get();
        CompanyInfo.CalcFields(Picture);
        PurchInvHeader_lRec.CalcFields("Amount Including VAT");

        RecRef.GetTable(PurchInvHeader_lRec);

        if not (WebportalReportSetup_gRec.Get(WebportalReportSetup_gRec."Report Name"::"Posted Purchase Invoice")) then
            Error('Access Denied');

        WebportalReportSetup_gRec.Reset();

        WebportalReportSetup_gRec.Get(WebportalReportSetup_gRec."Report Name"::"Posted Purchase Invoice");
        WebportalReportSetup_gRec.TestField("Report ID");

        ClearGlobVar;
        Rpt_TempBlob.CreateOutStream(Rpt_OutStream);
        Report.SaveAs(WebportalReportSetup_gRec."Report ID", '', ReportFormat::Pdf, Rpt_OutStream, RecRef);
        Rpt_TempBlob.CreateInStream(Rpt_InStream);
        Base64_vTxt := Base64Convert.ToBase64(Rpt_InStream);
        FileName_vTxt := FileMgt_gCdu.StripNotsupportChrInFileName('PostedPurchaseInvoice_' + DocumentNo_iCod) + '.pdf';

        exit(true);
    end;

    procedure PrintPostedPurchRcpt_gFnc(DocumentNo_iCod: Code[20]; var Base64_vTxt: Text; var FileName_vTxt: Text): Boolean
    var
        CompanyInfo: Record "Company Information";
        PurchRcptHeader_lRec: Record "Purch. Rcpt. Header";
        Vendor: Record Vendor;
        Email: Codeunit Email;
        EmailMessage: Codeunit "Email Message";

        BCC: List of [Text];
        CC: List of [Text];
        Recepients: List of [Text];

        BodyHTML_lTxt: Text;
        XMLParameter: Text;
    begin
        PurchRcptHeader_lRec.Reset();
        PurchRcptHeader_lRec.SetRange("No.", DocumentNo_iCod);
        if not PurchRcptHeader_lRec.FindFirst() then
            Error('Purchase Receipt doesnot exists with Document No. %1', DocumentNo_iCod);

        Clear(Vendor);
        Vendor.Get(PurchRcptHeader_lRec."Buy-from Vendor No.");

        //XMLParameter := Report.RunRequestPage(408);

        // SMTPMailsetup.Get();
        // SMTPMailsetup.TestField("User ID");

        //Clear(SMTPMail);
        Recepients.Add(UserID);
        //SMTPMail.CreateMessage('Intech Systems Pvt. Ltd.', SMTPMailsetup."User ID", Recepients, 'D365 Business Central', '');

        Clear(CompanyInfo);
        CompanyInfo.Get();
        CompanyInfo.CalcFields(Picture);

        RecRef.GetTable(PurchRcptHeader_lRec);

        ClearGlobVar;
        Rpt_TempBlob.CreateOutStream(Rpt_OutStream);

        if not (WebportalReportSetup_gRec.Get(WebportalReportSetup_gRec."Report Name"::"Posted Purchase Receipt")) then
            Error('Access Denied');

        WebportalReportSetup_gRec.Reset();

        WebportalReportSetup_gRec.Get(WebportalReportSetup_gRec."Report Name"::"Posted Purchase Receipt");
        WebportalReportSetup_gRec.TestField("Report ID");

        Report.SaveAs(WebportalReportSetup_gRec."Report ID", '', ReportFormat::Pdf, Rpt_OutStream, RecRef);

        Rpt_TempBlob.CreateInStream(Rpt_InStream);
        Base64_vTxt := Base64Convert.ToBase64(Rpt_InStream);
        FileName_vTxt := FileMgt_gCdu.StripNotsupportChrInFileName('PurchaseReceipt_' + DocumentNo_iCod) + '.pdf';
        exit(true);
    end;

    procedure PrintPostedSalesShipment_gFnc(DocumentNo_iCod: Code[20]; var Base64_vTxt: Text; var FileName_vTxt: Text): Boolean
    var
        CompanyInfo: Record "Company Information";
        SalesShipmentHeader_lRec: Record "Sales Shipment Header";
        Customer_lRec: Record Customer;
        Email: Codeunit Email;
        EmailMessage: Codeunit "Email Message";

        BCC: List of [Text];
        CC: List of [Text];
        Recepients: List of [Text];

        BodyHTML_lTxt: Text;
        XMLParameter: Text;
    begin
        SalesShipmentHeader_lRec.Reset();
        SalesShipmentHeader_lRec.SetRange("No.", DocumentNo_iCod);
        if not SalesShipmentHeader_lRec.FindFirst() then
            Error('Sales Shipment doesnot exists with Document No. %1', DocumentNo_iCod);

        Clear(Customer_lRec);
        Customer_lRec.Get(SalesShipmentHeader_lRec."Sell-to Customer No.");

        //XMLParameter := Report.RunRequestPage(408);

        // SMTPMailsetup.Get();
        // SMTPMailsetup.TestField("User ID");

        //Clear(SMTPMail);
        Recepients.Add(UserID);
        //SMTPMail.CreateMessage('Intech Systems Pvt. Ltd.', SMTPMailsetup."User ID", Recepients, 'D365 Business Central', '');

        Clear(CompanyInfo);
        CompanyInfo.Get();
        CompanyInfo.CalcFields(Picture);

        RecRef.GetTable(SalesShipmentHeader_lRec);

        ClearGlobVar;
        Rpt_TempBlob.CreateOutStream(Rpt_OutStream);

        if not (WebportalReportSetup_gRec.Get(WebportalReportSetup_gRec."Report Name"::"Posted Sales Shipment")) then
            Error('Access Denied');

        WebportalReportSetup_gRec.Reset();

        WebportalReportSetup_gRec.Get(WebportalReportSetup_gRec."Report Name"::"Posted Sales Shipment");
        WebportalReportSetup_gRec.TestField("Report ID");

        Report.SaveAs(WebportalReportSetup_gRec."Report ID", '', ReportFormat::Pdf, Rpt_OutStream, RecRef);

        Rpt_TempBlob.CreateInStream(Rpt_InStream);
        Base64_vTxt := Base64Convert.ToBase64(Rpt_InStream);
        FileName_vTxt := FileMgt_gCdu.StripNotsupportChrInFileName('SaleShipment_' + DocumentNo_iCod) + '.pdf';
        exit(true);
    end;


    procedure PrintPurchaseQuote_gFnc(DocumentNo_iCod: Code[20]; var Base64_vTxt: Text; var FileName_vTxt: Text): Boolean
    var
        CompanyInfo: Record "Company Information";
        PurchaseHeader_lRec: Record "Purchase Header";
        Vendor: Record Vendor;
        Email: Codeunit Email;
        EmailMessage: Codeunit "Email Message";

        BCC: List of [Text];
        CC: List of [Text];
        Recepients: List of [Text];

        BodyHTML_lTxt: Text;
        XMLParameter: Text;

    begin
        PurchaseHeader_lRec.Reset();
        PurchaseHeader_lRec.SetRange("Document Type", PurchaseHeader_lRec."Document Type"::Quote);
        PurchaseHeader_lRec.SetRange("No.", DocumentNo_iCod);
        if not PurchaseHeader_lRec.FindFirst() then
            Error('Purchase Quote doesnot exists with Document No. %1', DocumentNo_iCod);


        Recepients.Add(UserID);

        RecRef.GetTable(PurchaseHeader_lRec);

        if not (WebportalReportSetup_gRec.Get(WebportalReportSetup_gRec."Report Name"::"Purchase Quote")) then
            Error('Access Denied');

        WebportalReportSetup_gRec.Reset();

        WebportalReportSetup_gRec.Get(WebportalReportSetup_gRec."Report Name"::"Purchase Quote");
        WebportalReportSetup_gRec.TestField("Report ID");

        ClearGlobVar;
        Rpt_TempBlob.CreateOutStream(Rpt_OutStream);
        Report.SaveAs(WebportalReportSetup_gRec."Report ID", '', REPORTFORMAT::Pdf, Rpt_OutStream, RecRef);
        Rpt_TempBlob.CreateInStream(Rpt_InStream);
        Base64_vTxt := Base64Convert.ToBase64(Rpt_InStream);
        FileName_vTxt := FileMgt_gCdu.StripNotsupportChrInFileName('PurchaseQuote_' + DocumentNo_iCod) + '.pdf';

        exit(true);
    end;


    local procedure ClearGlobVar()
    begin
        Clear(Rpt_TempBlob);
        Clear(Rpt_InStream);
        Clear(Rpt_OutStream);
        Clear(Base64Convert);
    end;

    var
        ObjectJArray_1: JsonArray;
        Rpt_TempBlob: Codeunit "Temp Blob";
        Rpt_InStream: InStream;
        Rpt_OutStream: OutStream;
        Base64Convert: Codeunit "Base64 Convert";
        RecRef: RecordRef;
        FileMgt_gCdu: Codeunit "File Management";

        WebportalReportSetup_gRec: Record Webportal_ReportIDSetup;

}

