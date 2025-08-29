codeunit 81233 "INT Web Portal Report (Email)"
{
    // version WebPortal

    trigger OnRun()
    begin
        //MESSAGE(PrintPostedSalesInvoice_gFnc('STINV-1314-00011'));
        //PrintPostedSalesInvoice_gFnc('R/1617/0268');
    end;

    var
        WebPortalSetup_gRec: Record "INT Web Portal - Setup";

    procedure PrintPostedSalesInvoice_gFnc(DocumentNo_iCod: Code[20]; UserID: Code[80]): Boolean
    var
        CompanyInfo: Record "Company Information";
        Customer: Record Customer;
        SalesInvoiceHeader_lRec: Record "Sales Invoice Header";
        Email: Codeunit Email;
        EmailMessage: Codeunit "Email Message";
        TempBlob: Codeunit "Temp Blob";
        EmailInStream: InStream;
        BCC: List of [Text];
        CC: List of [Text];
        Recepients: List of [Text];
        EmailoutStream: OutStream;
        BodyHTML_lTxt: Text;
        XMLParameter: Text;
    begin
        SalesInvoiceHeader_lRec.Reset();
        SalesInvoiceHeader_lRec.SetRange("No.", DocumentNo_iCod);
        if not SalesInvoiceHeader_lRec.FindFirst() then
            Error('Sales Invoice doesnot exists with Document No. %1', DocumentNo_iCod);

        Clear(Customer);
        Customer.Get(SalesInvoiceHeader_lRec."Sell-to Customer No.");
        Clear(CompanyInfo);
        CompanyInfo.Get();

        //XMLParameter := Report.RunRequestPage(206);
        Recepients.Add(UserID);
        //SMTPMail.CreateMessage('Intech Systems Pvt. Ltd.', SMTPMailSetup."User ID", Recepients, 'D365 Business Central', '');
        Clear(CompanyInfo);
        CompanyInfo.Get();
        CompanyInfo.CalcFields(Picture);
        SalesInvoiceHeader_lRec.CalcFields("Amount Including VAT");

        BodyHTML_lTxt += '<html>';
        BodyHTML_lTxt += '<head>';
        BodyHTML_lTxt += '<meta charset="utf-8">';
        BodyHTML_lTxt += '<title>A simple, clean, and responsive HTML invoice template</title>';

        BodyHTML_lTxt += '<style>';
        BodyHTML_lTxt += '.invoice-box {';
        BodyHTML_lTxt += 'max-width: 800px;';
        BodyHTML_lTxt += 'margin: auto;';
        BodyHTML_lTxt += 'padding: 30px;';
        BodyHTML_lTxt += 'border: 1px solid #eee;';
        BodyHTML_lTxt += 'box-shadow: 0 0 10px rgba(0, 0, 0, .15);';
        BodyHTML_lTxt += 'font-size: 16px;';
        BodyHTML_lTxt += 'line-height: 24px;';
        BodyHTML_lTxt += 'font-family: ''Helvetica Neue'', ''Helvetica'', Helvetica, Arial, sans-serif;';
        BodyHTML_lTxt += 'color: #555;';
        BodyHTML_lTxt += '}';

        BodyHTML_lTxt += '.invoice-box table {';
        BodyHTML_lTxt += 'width: 100%;';
        BodyHTML_lTxt += 'line-height: inherit;';
        BodyHTML_lTxt += 'text-align: left;';
        BodyHTML_lTxt += '}';

        BodyHTML_lTxt += '.invoice-box table td {';
        BodyHTML_lTxt += 'padding: 5px;';
        BodyHTML_lTxt += 'vertical-align: top;';
        BodyHTML_lTxt += '}';

        BodyHTML_lTxt += '.invoice-box table tr td:nth-child(2 {';
        BodyHTML_lTxt += 'text-align: right;';
        BodyHTML_lTxt += '}';

        BodyHTML_lTxt += '.invoice-box table tr.top table td {';
        BodyHTML_lTxt += 'padding-bottom: 20px;';
        BodyHTML_lTxt += '}';

        BodyHTML_lTxt += '.invoice-box table tr.top table td.title {';
        BodyHTML_lTxt += 'font-size: 45px;';
        BodyHTML_lTxt += 'line-height: 45px;';
        BodyHTML_lTxt += 'color: #333;';
        BodyHTML_lTxt += '}';

        BodyHTML_lTxt += '.invoice-box table tr.information table td {';
        BodyHTML_lTxt += 'padding-bottom: 40px;';
        BodyHTML_lTxt += '}';

        BodyHTML_lTxt += '.invoice-box table tr.heading td {';
        BodyHTML_lTxt += 'background: #eee;';
        BodyHTML_lTxt += 'border-bottom: 1px solid #ddd;';
        BodyHTML_lTxt += 'font-weight: bold;';
        BodyHTML_lTxt += '}';

        BodyHTML_lTxt += '.invoice-box table tr.details td {';
        BodyHTML_lTxt += 'padding-bottom: 20px;';
        BodyHTML_lTxt += '}';

        BodyHTML_lTxt += '.invoice-box table tr.item td{';
        BodyHTML_lTxt += 'border-bottom: 1px solid #eee;';
        BodyHTML_lTxt += '}';

        BodyHTML_lTxt += '.invoice-box table tr.item.last td {';
        BodyHTML_lTxt += 'border-bottom: none;';
        BodyHTML_lTxt += '}';

        BodyHTML_lTxt += '.invoice-box table tr.total td:nth-child(2 {';
        BodyHTML_lTxt += 'border-top: 2px solid #eee;';
        BodyHTML_lTxt += 'font-weight: bold;';
        BodyHTML_lTxt += '}';

        BodyHTML_lTxt += '@media only screen and (max-width: 600px) {';
        BodyHTML_lTxt += '.invoice-box table tr.top table td {';
        BodyHTML_lTxt += 'width: 100%;';
        BodyHTML_lTxt += 'display: block;';
        BodyHTML_lTxt += 'text-align: center;';
        BodyHTML_lTxt += '}';

        BodyHTML_lTxt += '.invoice-box table tr.information table td {';
        BodyHTML_lTxt += 'width: 100%;';
        BodyHTML_lTxt += 'display: block;';
        BodyHTML_lTxt += 'text-align: center;';
        BodyHTML_lTxt += '}';
        BodyHTML_lTxt += '}';

        BodyHTML_lTxt += '/** RTL **/';
        BodyHTML_lTxt += '.rtl {';
        BodyHTML_lTxt += 'direction: rtl;';
        BodyHTML_lTxt += 'font-family: Tahoma, ''Helvetica Neue'', ''Helvetica'', Helvetica, Arial, sans-serif;';
        BodyHTML_lTxt += '}';

        BodyHTML_lTxt += '.rtl table {';
        BodyHTML_lTxt += 'text-align: right;';
        BodyHTML_lTxt += '}';

        BodyHTML_lTxt += '.rtl table tr td:nth-child(2) {';
        BodyHTML_lTxt += 'text-align: left;';
        BodyHTML_lTxt += '}';
        BodyHTML_lTxt += '</style>';
        BodyHTML_lTxt += '</head>';

        BodyHTML_lTxt += '<body>';
        BodyHTML_lTxt += '<div class="invoice-box">';
        BodyHTML_lTxt += '<table cellpadding="0" cellspacing="0">';
        BodyHTML_lTxt += '<tr class="top">';
        BodyHTML_lTxt += '<td colspan="2">';
        BodyHTML_lTxt += '<table>';
        BodyHTML_lTxt += '<tr>';
        BodyHTML_lTxt += '<td>';
        BodyHTML_lTxt += '<img src="https://106c4.wpc.azureedge.net/80106C4/Gallery-Prod/cdn/2015-02-24/prod20161101-microsoft-windowsazure-gallery/microsoftdynsmb.3a67602d-0a4f-4ae4-ad03-c1124f6ac3cf.1.0.2/Icon/large.png" height="100" width="100">';
        BodyHTML_lTxt += '</td>';

        BodyHTML_lTxt += '<td class="title">';
        BodyHTML_lTxt += '<b><font size = "5">Sales Invoice</font></b><br>';
        BodyHTML_lTxt += '</td>';
        BodyHTML_lTxt += '</tr>';
        BodyHTML_lTxt += '</table>';
        BodyHTML_lTxt += '</td>';
        BodyHTML_lTxt += '</tr>';

        BodyHTML_lTxt += '<tr class="information">';
        BodyHTML_lTxt += '<td colspan="2">';
        BodyHTML_lTxt += '<table>';
        BodyHTML_lTxt += '<tr>';
        BodyHTML_lTxt += '<td>';
        BodyHTML_lTxt += CompanyInfo.Name + '<br>';
        BodyHTML_lTxt += CompanyInfo.Address + '<br>';
        BodyHTML_lTxt += CompanyInfo."Address 2" + '<br>';
        BodyHTML_lTxt += CompanyInfo.City + '<br>';
        BodyHTML_lTxt += CompanyInfo."Post Code" + '<br>';
        BodyHTML_lTxt += CompanyInfo."Phone No." + '<br>';
        BodyHTML_lTxt += '</td>';

        BodyHTML_lTxt += '<td>';
        BodyHTML_lTxt += CompanyInfo."Contact Person" + '<br>';
        BodyHTML_lTxt += CompanyInfo."E-Mail" + '<br>';
        BodyHTML_lTxt += 'Created Date:' + Format(CurrentDateTime()) + '<br>';
        BodyHTML_lTxt += '</td>';
        BodyHTML_lTxt += '</tr>';
        BodyHTML_lTxt += '</table>';
        BodyHTML_lTxt += '</td>';
        BodyHTML_lTxt += '</tr>';

        BodyHTML_lTxt += '<tr class="heading">';
        BodyHTML_lTxt += '<td>';
        BodyHTML_lTxt += 'Account No.';
        BodyHTML_lTxt += '</td>';

        BodyHTML_lTxt += '<td>';
        BodyHTML_lTxt += Customer."No.";
        BodyHTML_lTxt += '</td>';
        BodyHTML_lTxt += '</tr>';

        BodyHTML_lTxt += '<tr class="details">';
        BodyHTML_lTxt += '<td>';
        BodyHTML_lTxt += 'Name';
        BodyHTML_lTxt += '</td>';

        BodyHTML_lTxt += '<td>';
        BodyHTML_lTxt += Customer.Name;
        BodyHTML_lTxt += '</td>';
        BodyHTML_lTxt += '</tr>';

        BodyHTML_lTxt += '<tr class="heading">';
        BodyHTML_lTxt += '<td>';
        BodyHTML_lTxt += 'Details:';
        BodyHTML_lTxt += '</td>';

        BodyHTML_lTxt += '<td>';
        BodyHTML_lTxt += '';
        BodyHTML_lTxt += '</td>';
        BodyHTML_lTxt += '</tr>';

        BodyHTML_lTxt += '<tr class="item">';
        BodyHTML_lTxt += '<td>';
        BodyHTML_lTxt += 'Document No.';
        BodyHTML_lTxt += '</td>';

        BodyHTML_lTxt += '<td>';
        BodyHTML_lTxt += DocumentNo_iCod;
        BodyHTML_lTxt += '</td>';
        BodyHTML_lTxt += '</tr>';

        BodyHTML_lTxt += '<tr class="item">';
        BodyHTML_lTxt += '<td>';
        BodyHTML_lTxt += 'Order Date';
        BodyHTML_lTxt += '</td>';

        BodyHTML_lTxt += '<td>';
        BodyHTML_lTxt += Format(SalesInvoiceHeader_lRec."Order Date");
        BodyHTML_lTxt += '</td>';
        BodyHTML_lTxt += '</tr>';

        BodyHTML_lTxt += '<tr class="item last">';
        BodyHTML_lTxt += '<td>';
        BodyHTML_lTxt += '';
        BodyHTML_lTxt += '</td>';

        BodyHTML_lTxt += '<td>';
        BodyHTML_lTxt += '</td>';
        BodyHTML_lTxt += '</tr>';

        BodyHTML_lTxt += '<tr class="heading">';
        BodyHTML_lTxt += '<td>';
        BodyHTML_lTxt += 'Total';
        BodyHTML_lTxt += '</td>';

        BodyHTML_lTxt += '<td>';
        BodyHTML_lTxt += Format(SalesInvoiceHeader_lRec."Amount Including VAT");
        BodyHTML_lTxt += '</td>';
        BodyHTML_lTxt += '</tr>';

        BodyHTML_lTxt += '</table>';
        BodyHTML_lTxt += '</div>';
        BodyHTML_lTxt += '</body>';
        BodyHTML_lTxt += '</html>';
        BodyHTML_lTxt += '<br><br>Kindly go through attached Document for more details.';
        BodyHTML_lTxt += '<br><br>Regards,<br><b>';
        BodyHTML_lTxt += CompanyInfo."Contact Person" + '<br>';
        BodyHTML_lTxt += CompanyInfo.Name + '<br>';
        BodyHTML_lTxt += CompanyInfo.Address + '<br>';
        BodyHTML_lTxt += CompanyInfo."Address 2" + '<br>';
        BodyHTML_lTxt += CompanyInfo.City + ',';
        BodyHTML_lTxt += CompanyInfo."Post Code" + '<br>';
        BodyHTML_lTxt += CompanyInfo."Phone No." + '<br>';
        BodyHTML_lTxt += CompanyInfo."E-Mail" + '<br></b>';


        WebPortalSetup_gRec.Get();
        if WebPortalSetup_gRec."Email as CC for Cust/Vend" then begin
            Clear(Recepients);
            Recepients.Add(Customer."E-Mail");
            CC.Add(Customer."E-Mail");
        end;

        EmailMessage.Create(Recepients, 'D365 Business Central', BodyHTML_lTxt, true, CC, BCC);

        XMLParameter := '<?xml version="1.0" standalone="yes"?><ReportParameters name="Sales - Invoice" id="206"><Options><Field name="NoOfCopies">0</Field><Field name="ShowInternalInfo">false</Field><Field name="LogInteraction">true</Field><Field name="DisplayAssemblyInformation">false</Field><Field name="DisplayAdditionalFeeNote">false</Field></Options><DataItems><DataItem name="Sales Invoice Header">VERSION(1) SORTING(Field3) WHERE(Field3=1(' + SalesInvoiceHeader_lRec."No." + '))</DataItem><DataItem name="CopyLoop">VERSION(1) SORTING(Field1)</DataItem><DataItem name="PageLoop">VERSION(1) SORTING(Field1)</DataItem><DataItem name="DimensionLoop1">VERSION(1) SORTING(Field1)</DataItem><DataItem name="Sales Invoice Line">VERSION(1) SORTING(Field3,Field4)</DataItem><DataItem name="Sales Shipment Buffer">VERSION(1) SORTING(Field1)</DataItem><DataItem name="DimensionLoop2">VERSION(1) SORTING(Field1)</DataItem><DataItem name="AsmLoop">VERSION(1) SORTING(Field1)</DataItem><DataItem name="VATCounter">VERSION(1) SORTING(Field1)</DataItem><DataItem name="VatCounterLCY">VERSION(1) SORTING(Field1)</DataItem><DataItem name="PaymentReportingArgument">VERSION(1) SORTING(Field1)</DataItem><DataItem name="Total">VERSION(1) SORTING(Field1)</DataItem><DataItem name="Total2">VERSION(1) SORTING(Field1)</DataItem><DataItem name="LineFee">VERSION(1) SORTING(Field1)</DataItem></DataItems></ReportParameters>';
        TempBlob.CreateOutStream(EmailoutStream);
        Report.SaveAs(206, XMLParameter, ReportFormat::Pdf, EmailoutStream);
        TempBlob.CreateInStream(EmailInStream);
        EmailMessage.AddAttachment('SalesInvoice' + DocumentNo_iCod + '.pdf', 'PDF', EmailInStream);

        // if SMTPMail.TrySend() then begin
        //     Message('Email Sent Successfully');
        //     exit(true);
        // end;
        Clear(Email);
        if Email.Send(EmailMessage, Enum::"Email Scenario"::Default) then begin
            if GuiAllowed then
                Message('Email Sent Successfully');
            exit(true);
        end;
    end;

    procedure PrintPostedSalesCreditNote_gFnc(DocumentNo_iCod: Code[20]; UserID: Code[80]): Boolean
    var
        CompanyInfo: Record "Company Information";
        Customer: Record Customer;
        SalesCrMemoHeader_lRec: Record "Sales Cr.Memo Header";
        Email: Codeunit Email;
        EmailMessage: Codeunit "Email Message";
        TempBlob: Codeunit "Temp Blob";
        EmailInStream: InStream;
        BCC: List of [Text];
        CC: List of [Text];
        Recepients: List of [Text];
        EmailoutStream: OutStream;
        BodyHTML_lTxt: Text;
        XMLParameter: Text;
    begin
        SalesCrMemoHeader_lRec.Reset();
        SalesCrMemoHeader_lRec.SetRange("No.", DocumentNo_iCod);
        if not SalesCrMemoHeader_lRec.FindFirst() then
            Error('Sales Cr. Memo doesnot exists with Document No. %1', DocumentNo_iCod);

        Clear(Customer);
        Customer.Get(SalesCrMemoHeader_lRec."Sell-to Customer No.");

        //XMLParameter := Report.RunRequestPage(207);

        Recepients.Add(UserID);
        //SMTPMail.CreateMessage('Intech Systems Pvt. Ltd.', SMTPMailsetup."User ID", Recepients, 'D365 Business Central', '');

        Clear(CompanyInfo);
        CompanyInfo.Get();
        CompanyInfo.CalcFields(Picture);
        SalesCrMemoHeader_lRec.CalcFields("Amount Including VAT");

        BodyHTML_lTxt += '<html>';
        BodyHTML_lTxt += '<head>';
        BodyHTML_lTxt += '<meta charset="utf-8">';
        BodyHTML_lTxt += '<title>A simple, clean, and responsive HTML invoice template</title>';

        BodyHTML_lTxt += '<style>';
        BodyHTML_lTxt += '.invoice-box {';
        BodyHTML_lTxt += 'max-width: 800px;';
        BodyHTML_lTxt += 'margin: auto;';
        BodyHTML_lTxt += 'padding: 30px;';
        BodyHTML_lTxt += 'border: 1px solid #eee;';
        BodyHTML_lTxt += 'box-shadow: 0 0 10px rgba(0, 0, 0, .15;';
        BodyHTML_lTxt += 'font-size: 16px;';
        BodyHTML_lTxt += 'line-height: 24px;';
        BodyHTML_lTxt += 'font-family: ''Helvetica Neue'', ''Helvetica'', Helvetica, Arial, sans-serif;';
        BodyHTML_lTxt += 'color: #555;';
        BodyHTML_lTxt += '}';

        BodyHTML_lTxt += '.invoice-box table {';
        BodyHTML_lTxt += 'width: 100%;';
        BodyHTML_lTxt += 'line-height: inherit;';
        BodyHTML_lTxt += 'text-align: left;';
        BodyHTML_lTxt += '}';

        BodyHTML_lTxt += '.invoice-box table td {';
        BodyHTML_lTxt += 'padding: 5px;';
        BodyHTML_lTxt += 'vertical-align: top;';
        BodyHTML_lTxt += '}';

        BodyHTML_lTxt += '.invoice-box table tr td:nth-child(2) {';
        BodyHTML_lTxt += 'text-align: right;';
        BodyHTML_lTxt += '}';

        BodyHTML_lTxt += '.invoice-box table tr.top table td {';
        BodyHTML_lTxt += 'padding-bottom: 20px;';
        BodyHTML_lTxt += '}';

        BodyHTML_lTxt += '.invoice-box table tr.top table td.title {';
        BodyHTML_lTxt += 'font-size: 45px;';
        BodyHTML_lTxt += 'line-height: 45px;';
        BodyHTML_lTxt += 'color: #333;';
        BodyHTML_lTxt += '}';

        BodyHTML_lTxt += '.invoice-box table tr.information table td {';
        BodyHTML_lTxt += 'padding-bottom: 40px;';
        BodyHTML_lTxt += '}';

        BodyHTML_lTxt += '.invoice-box table tr.heading td {';
        BodyHTML_lTxt += 'background: #eee;';
        BodyHTML_lTxt += 'border-bottom: 1px solid #ddd;';
        BodyHTML_lTxt += 'font-weight: bold;';
        BodyHTML_lTxt += '}';

        BodyHTML_lTxt += '.invoice-box table tr.details td {';
        BodyHTML_lTxt += 'padding-bottom: 20px;';
        BodyHTML_lTxt += '}';

        BodyHTML_lTxt += '.invoice-box table tr.item td{';
        BodyHTML_lTxt += 'border-bottom: 1px solid #eee;';
        BodyHTML_lTxt += '}';

        BodyHTML_lTxt += '.invoice-box table tr.item.last td {';
        BodyHTML_lTxt += 'border-bottom: none;';
        BodyHTML_lTxt += '}';

        BodyHTML_lTxt += '.invoice-box table tr.total td:nth-child(2) {';
        BodyHTML_lTxt += 'border-top: 2px solid #eee;';
        BodyHTML_lTxt += 'font-weight: bold;';
        BodyHTML_lTxt += '}';

        BodyHTML_lTxt += '@media only screen and (max-width: 600px) {';
        BodyHTML_lTxt += '.invoice-box table tr.top table td {';
        BodyHTML_lTxt += 'width: 100%;';
        BodyHTML_lTxt += 'display: block;';
        BodyHTML_lTxt += 'text-align: center;';
        BodyHTML_lTxt += '}';

        BodyHTML_lTxt += '.invoice-box table tr.information table td {';
        BodyHTML_lTxt += 'width: 100%;';
        BodyHTML_lTxt += 'display: block;';
        BodyHTML_lTxt += 'text-align: center;';
        BodyHTML_lTxt += '}';
        BodyHTML_lTxt += '}';

        BodyHTML_lTxt += '/** RTL **/';
        BodyHTML_lTxt += '.rtl {';
        BodyHTML_lTxt += 'direction: rtl;';
        BodyHTML_lTxt += 'font-family: Tahoma, ''Helvetica Neue'', ''Helvetica'', Helvetica, Arial, sans-serif;';
        BodyHTML_lTxt += '}';

        BodyHTML_lTxt += '.rtl table {';
        BodyHTML_lTxt += 'text-align: right;';
        BodyHTML_lTxt += '}';

        BodyHTML_lTxt += '.rtl table tr td:nth-child(2) {';
        BodyHTML_lTxt += 'text-align: left;';
        BodyHTML_lTxt += '}';
        BodyHTML_lTxt += '</style>';
        BodyHTML_lTxt += '</head>';

        BodyHTML_lTxt += '<body>';
        BodyHTML_lTxt += '<div class="invoice-box">';
        BodyHTML_lTxt += '<table cellpadding="0" cellspacing="0">';
        BodyHTML_lTxt += '<tr class="top">';
        BodyHTML_lTxt += '<td colspan="2">';
        BodyHTML_lTxt += '<table>';
        BodyHTML_lTxt += '<tr>';
        BodyHTML_lTxt += '<td>';
        BodyHTML_lTxt += '<img src="https://106c4.wpc.azureedge.net/80106C4/Gallery-Prod/cdn/2015-02-24/prod20161101-microsoft-windowsazure-gallery/microsoftdynsmb.3a67602d-0a4f-4ae4-ad03-c1124f6ac3cf.1.0.2/Icon/large.png" height="100" width="100">';
        BodyHTML_lTxt += '</td>';

        BodyHTML_lTxt += '<td class="title">';
        BodyHTML_lTxt += '<b><font size = "5">Sales Credit Note</font></b><br>';
        BodyHTML_lTxt += '</td>';
        BodyHTML_lTxt += '</tr>';
        BodyHTML_lTxt += '</table>';
        BodyHTML_lTxt += '</td>';
        BodyHTML_lTxt += '</tr>';

        BodyHTML_lTxt += '<tr class="information">';
        BodyHTML_lTxt += '<td colspan="2">';
        BodyHTML_lTxt += '<table>';
        BodyHTML_lTxt += '<tr>';
        BodyHTML_lTxt += '<td>';
        BodyHTML_lTxt += CompanyInfo.Name + '<br>';
        BodyHTML_lTxt += CompanyInfo.Address + '<br>';
        BodyHTML_lTxt += CompanyInfo."Address 2" + '<br>';
        BodyHTML_lTxt += CompanyInfo.City + '<br>';
        BodyHTML_lTxt += CompanyInfo."Post Code" + '<br>';
        BodyHTML_lTxt += CompanyInfo."Phone No." + '<br>';
        BodyHTML_lTxt += '</td>';

        BodyHTML_lTxt += '<td>';
        BodyHTML_lTxt += CompanyInfo."Contact Person" + '<br>';
        BodyHTML_lTxt += CompanyInfo."E-Mail" + '<br>';
        BodyHTML_lTxt += 'Created Date:' + Format(CurrentDateTime()) + '<br>';
        BodyHTML_lTxt += '</td>';
        BodyHTML_lTxt += '</tr>';
        BodyHTML_lTxt += '</table>';
        BodyHTML_lTxt += '</td>';
        BodyHTML_lTxt += '</tr>';

        BodyHTML_lTxt += '<tr class="heading">';
        BodyHTML_lTxt += '<td>';
        BodyHTML_lTxt += 'Account No.';
        BodyHTML_lTxt += '</td>';

        BodyHTML_lTxt += '<td>';
        BodyHTML_lTxt += Customer."No.";
        BodyHTML_lTxt += '</td>';
        BodyHTML_lTxt += '</tr>';

        BodyHTML_lTxt += '<tr class="details">';
        BodyHTML_lTxt += '<td>';
        BodyHTML_lTxt += 'Name';
        BodyHTML_lTxt += '</td>';

        BodyHTML_lTxt += '<td>';
        BodyHTML_lTxt += Customer.Name;
        BodyHTML_lTxt += '</td>';
        BodyHTML_lTxt += '</tr>';

        BodyHTML_lTxt += '<tr class="heading">';
        BodyHTML_lTxt += '<td>';
        BodyHTML_lTxt += 'Details:';
        BodyHTML_lTxt += '</td>';

        BodyHTML_lTxt += '<td>';
        BodyHTML_lTxt += '';
        BodyHTML_lTxt += '</td>';
        BodyHTML_lTxt += '</tr>';

        BodyHTML_lTxt += '<tr class="item">';
        BodyHTML_lTxt += '<td>';
        BodyHTML_lTxt += 'Document No.';
        BodyHTML_lTxt += '</td>';

        BodyHTML_lTxt += '<td>';
        BodyHTML_lTxt += DocumentNo_iCod;
        BodyHTML_lTxt += '</td>';
        BodyHTML_lTxt += '</tr>';

        BodyHTML_lTxt += '<tr class="item">';
        BodyHTML_lTxt += '<td>';
        BodyHTML_lTxt += 'Order Date';
        BodyHTML_lTxt += '</td>';

        BodyHTML_lTxt += '<td>';
        BodyHTML_lTxt += Format(SalesCrMemoHeader_lRec."Posting Date");
        BodyHTML_lTxt += '</td>';
        BodyHTML_lTxt += '</tr>';

        BodyHTML_lTxt += '<tr class="item last">';
        BodyHTML_lTxt += '<td>';
        BodyHTML_lTxt += '';
        BodyHTML_lTxt += '</td>';

        BodyHTML_lTxt += '<td>';
        BodyHTML_lTxt += '</td>';
        BodyHTML_lTxt += '</tr>';

        BodyHTML_lTxt += '<tr class="heading">';
        BodyHTML_lTxt += '<td>';
        BodyHTML_lTxt += 'Total';
        BodyHTML_lTxt += '</td>';

        BodyHTML_lTxt += '<td>';
        BodyHTML_lTxt += Format(SalesCrMemoHeader_lRec."Amount Including VAT");
        BodyHTML_lTxt += '</td>';
        BodyHTML_lTxt += '</tr>';

        BodyHTML_lTxt += '</table>';
        BodyHTML_lTxt += '</div>';
        BodyHTML_lTxt += '</body>';
        BodyHTML_lTxt += '</html>';
        BodyHTML_lTxt += '<br><br>Kindly go through attached Document for more details.';
        BodyHTML_lTxt += '<br><br>Regards,<br><b>';
        BodyHTML_lTxt += CompanyInfo."Contact Person" + '<br>';
        BodyHTML_lTxt += CompanyInfo.Name + '<br>';
        BodyHTML_lTxt += CompanyInfo.Address + '<br>';
        BodyHTML_lTxt += CompanyInfo."Address 2" + '<br>';
        BodyHTML_lTxt += CompanyInfo.City + ',';
        BodyHTML_lTxt += CompanyInfo."Post Code" + '<br>';
        BodyHTML_lTxt += CompanyInfo."Phone No." + '<br>';
        BodyHTML_lTxt += CompanyInfo."E-Mail" + '<br></b>';

        WebPortalSetup_gRec.Get();
        if WebPortalSetup_gRec."Email as CC for Cust/Vend" then begin
            Clear(Recepients);
            Recepients.Add(Customer."E-Mail");
            CC.Add(Customer."E-Mail");
        end;

        EmailMessage.Create(Recepients, 'D365 Business Central', BodyHTML_lTxt, true, CC, BCC);

        XMLParameter := '<?xml version="1.0" standalone="yes"?><ReportParameters name="Sales - Credit Memo" id="207"><Options><Field name="NoOfCopies">0</Field><Field name="ShowInternalInfo">false</Field><Field name="LogInteraction">true</Field></Options><DataItems><DataItem name="Sales Cr.Memo Header">VERSION(1) SORTING(Field3) WHERE(Field3=1(' + SalesCrMemoHeader_lRec."No." + '))</DataItem><DataItem name="CopyLoop">VERSION(1) SORTING(Field1)</DataItem><DataItem name="PageLoop">VERSION(1) SORTING(Field1)</DataItem><DataItem name="DimensionLoop1">VERSION(1) SORTING(Field1)</DataItem><DataItem name="Sales Cr.Memo Line">VERSION(1) SORTING(Field3,Field4)</DataItem><DataItem name="DimensionLoop2">VERSION(1) SORTING(Field1)</DataItem><DataItem name="VATCounter">VERSION(1) SORTING(Field1)</DataItem><DataItem name="VATCounterLCY">VERSION(1) SORTING(Field1)</DataItem><DataItem name="Total">VERSION(1) SORTING(Field1)</DataItem><DataItem name="Total2">VERSION(1) SORTING(Field1)</DataItem></DataItems></ReportParameters>';
        TempBlob.CreateOutStream(EmailoutStream);
        Report.SaveAs(207, XMLParameter, ReportFormat::Pdf, EmailoutStream);
        TempBlob.CreateInStream(EmailInStream);

        EmailMessage.AddAttachment('SalesCreditNote' + DocumentNo_iCod + '.pdf', 'PDF', EmailInStream);

        // if SMTPMail.TrySend() then begin
        //     Message('Email Sent Successfully');
        //     exit(true);
        // end;
        Clear(Email);
        if Email.Send(EmailMessage, Enum::"Email Scenario"::Default) then begin
            if GuiAllowed then
                Message('Email Sent Successfully');
            exit(true);
        end;
    end;

    procedure PrintSalesOrder_gFnc(DocumentNo_iCod: Code[20]; UserID: Code[80]): Boolean
    var
        CompanyInfo: Record "Company Information";
        Customer: Record Customer;
        SalesHeader_lRec: Record "Sales Header";
        Email: Codeunit Email;
        EmailMessage: Codeunit "Email Message";
        TempBlob: Codeunit "Temp Blob";
        EmailInStream: InStream;
        BCC: List of [Text];
        CC: List of [Text];
        Recepients: List of [Text];
        EmailoutStream: OutStream;
        BodyHTML_lTxt: Text;
        XMLParameter: Text;
    begin
        SalesHeader_lRec.Reset();
        SalesHeader_lRec.SetRange("Document Type", SalesHeader_lRec."Document Type"::Order);
        SalesHeader_lRec.SetRange("No.", DocumentNo_iCod);
        if not SalesHeader_lRec.FindFirst() then
            Error('Sales Order doesnot exists with Document No. %1', DocumentNo_iCod);

        Clear(Customer);
        Customer.Get(SalesHeader_lRec."Sell-to Customer No.");

        //XMLParameter := Report.RunRequestPage(205);

        Recepients.Add(UserID);
        //SMTPMail.CreateMessage('Intech Systems Pvt. Ltd.', SMTPMailsetup."User ID", Recepients, 'D365 Business Central', '');
        Clear(CompanyInfo);
        CompanyInfo.Get();
        CompanyInfo.CalcFields(Picture);
        SalesHeader_lRec.CalcFields("Amount Including VAT");

        BodyHTML_lTxt += '<html>';
        BodyHTML_lTxt += '<head>';
        BodyHTML_lTxt += '<meta charset="utf-8">';
        BodyHTML_lTxt += '<title>A simple, clean, and responsive HTML invoice template</title>';

        BodyHTML_lTxt += '<style>';
        BodyHTML_lTxt += '.invoice-box {';
        BodyHTML_lTxt += 'max-width: 800px;';
        BodyHTML_lTxt += 'margin: auto;';
        BodyHTML_lTxt += 'padding: 30px;';
        BodyHTML_lTxt += 'border: 1px solid #eee;';
        BodyHTML_lTxt += 'box-shadow: 0 0 10px rgba(0, 0, 0, .15;';
        BodyHTML_lTxt += 'font-size: 16px;';
        BodyHTML_lTxt += 'line-height: 24px;';
        BodyHTML_lTxt += 'font-family: ''Helvetica Neue'', ''Helvetica'', Helvetica, Arial, sans-serif;';
        BodyHTML_lTxt += 'color: #555;';
        BodyHTML_lTxt += '}';

        BodyHTML_lTxt += '.invoice-box table {';
        BodyHTML_lTxt += 'width: 100%;';
        BodyHTML_lTxt += 'line-height: inherit;';
        BodyHTML_lTxt += 'text-align: left;';
        BodyHTML_lTxt += '}';

        BodyHTML_lTxt += '.invoice-box table td {';
        BodyHTML_lTxt += 'padding: 5px;';
        BodyHTML_lTxt += 'vertical-align: top;';
        BodyHTML_lTxt += '}';

        BodyHTML_lTxt += '.invoice-box table tr td:nth-child(2) {';
        BodyHTML_lTxt += 'text-align: right;';
        BodyHTML_lTxt += '}';

        BodyHTML_lTxt += '.invoice-box table tr.top table td {';
        BodyHTML_lTxt += 'padding-bottom: 20px;';
        BodyHTML_lTxt += '}';

        BodyHTML_lTxt += '.invoice-box table tr.top table td.title {';
        BodyHTML_lTxt += 'font-size: 45px;';
        BodyHTML_lTxt += 'line-height: 45px;';
        BodyHTML_lTxt += 'color: #333;';
        BodyHTML_lTxt += '}';

        BodyHTML_lTxt += '.invoice-box table tr.information table td {';
        BodyHTML_lTxt += 'padding-bottom: 40px;';
        BodyHTML_lTxt += '}';

        BodyHTML_lTxt += '.invoice-box table tr.heading td {';
        BodyHTML_lTxt += 'background: #eee;';
        BodyHTML_lTxt += 'border-bottom: 1px solid #ddd;';
        BodyHTML_lTxt += 'font-weight: bold;';
        BodyHTML_lTxt += '}';

        BodyHTML_lTxt += '.invoice-box table tr.details td {';
        BodyHTML_lTxt += 'padding-bottom: 20px;';
        BodyHTML_lTxt += '}';

        BodyHTML_lTxt += '.invoice-box table tr.item td{';
        BodyHTML_lTxt += 'border-bottom: 1px solid #eee;';
        BodyHTML_lTxt += '}';

        BodyHTML_lTxt += '.invoice-box table tr.item.last td {';
        BodyHTML_lTxt += 'border-bottom: none;';
        BodyHTML_lTxt += '}';

        BodyHTML_lTxt += '.invoice-box table tr.total td:nth-child(2) {';
        BodyHTML_lTxt += 'border-top: 2px solid #eee;';
        BodyHTML_lTxt += 'font-weight: bold;';
        BodyHTML_lTxt += '}';

        BodyHTML_lTxt += '@media only screen and (max-width: 600px) {';
        BodyHTML_lTxt += '.invoice-box table tr.top table td {';
        BodyHTML_lTxt += 'width: 100%;';
        BodyHTML_lTxt += 'display: block;';
        BodyHTML_lTxt += 'text-align: center;';
        BodyHTML_lTxt += '}';

        BodyHTML_lTxt += '.invoice-box table tr.information table td {';
        BodyHTML_lTxt += 'width: 100%;';
        BodyHTML_lTxt += 'display: block;';
        BodyHTML_lTxt += 'text-align: center;';
        BodyHTML_lTxt += '}';
        BodyHTML_lTxt += '}';

        BodyHTML_lTxt += '/** RTL **/';
        BodyHTML_lTxt += '.rtl {';
        BodyHTML_lTxt += 'direction: rtl;';
        BodyHTML_lTxt += 'font-family: Tahoma, ''Helvetica Neue'', ''Helvetica'', Helvetica, Arial, sans-serif;';
        BodyHTML_lTxt += '}';

        BodyHTML_lTxt += '.rtl table {';
        BodyHTML_lTxt += 'text-align: right;';
        BodyHTML_lTxt += '}';

        BodyHTML_lTxt += '.rtl table tr td:nth-child(2) {';
        BodyHTML_lTxt += 'text-align: left;';
        BodyHTML_lTxt += '}';
        BodyHTML_lTxt += '</style>';
        BodyHTML_lTxt += '</head>';

        BodyHTML_lTxt += '<body>';
        BodyHTML_lTxt += '<div class="invoice-box">';
        BodyHTML_lTxt += '<table cellpadding="0" cellspacing="0">';
        BodyHTML_lTxt += '<tr class="top">';
        BodyHTML_lTxt += '<td colspan="2">';
        BodyHTML_lTxt += '<table>';
        BodyHTML_lTxt += '<tr>';
        BodyHTML_lTxt += '<td>';
        BodyHTML_lTxt += '<img src="https://106c4.wpc.azureedge.net/80106C4/Gallery-Prod/cdn/2015-02-24/prod20161101-microsoft-windowsazure-gallery/microsoftdynsmb.3a67602d-0a4f-4ae4-ad03-c1124f6ac3cf.1.0.2/Icon/large.png" height="100" width="100">';
        BodyHTML_lTxt += '</td>';

        BodyHTML_lTxt += '<td class="title">';
        BodyHTML_lTxt += '<b><font size = "5">Sales Order</font></b><br>';
        BodyHTML_lTxt += '</td>';
        BodyHTML_lTxt += '</tr>';
        BodyHTML_lTxt += '</table>';
        BodyHTML_lTxt += '</td>';
        BodyHTML_lTxt += '</tr>';

        BodyHTML_lTxt += '<tr class="information">';
        BodyHTML_lTxt += '<td colspan="2">';
        BodyHTML_lTxt += '<table>';
        BodyHTML_lTxt += '<tr>';
        BodyHTML_lTxt += '<td>';
        BodyHTML_lTxt += CompanyInfo.Name + '<br>';
        BodyHTML_lTxt += CompanyInfo.Address + '<br>';
        BodyHTML_lTxt += CompanyInfo."Address 2" + '<br>';
        BodyHTML_lTxt += CompanyInfo.City + '<br>';
        BodyHTML_lTxt += CompanyInfo."Post Code" + '<br>';
        BodyHTML_lTxt += CompanyInfo."Phone No." + '<br>';
        BodyHTML_lTxt += '</td>';

        BodyHTML_lTxt += '<td>';
        BodyHTML_lTxt += CompanyInfo."Contact Person" + '<br>';
        BodyHTML_lTxt += CompanyInfo."E-Mail" + '<br>';
        BodyHTML_lTxt += 'Created Date:' + Format(CurrentDateTime()) + '<br>';
        BodyHTML_lTxt += '</td>';
        BodyHTML_lTxt += '</tr>';
        BodyHTML_lTxt += '</table>';
        BodyHTML_lTxt += '</td>';
        BodyHTML_lTxt += '</tr>';

        BodyHTML_lTxt += '<tr class="heading">';
        BodyHTML_lTxt += '<td>';
        BodyHTML_lTxt += 'Account No.';
        BodyHTML_lTxt += '</td>';

        BodyHTML_lTxt += '<td>';
        BodyHTML_lTxt += Customer."No.";
        BodyHTML_lTxt += '</td>';
        BodyHTML_lTxt += '</tr>';

        BodyHTML_lTxt += '<tr class="details">';
        BodyHTML_lTxt += '<td>';
        BodyHTML_lTxt += 'Name';
        BodyHTML_lTxt += '</td>';

        BodyHTML_lTxt += '<td>';
        BodyHTML_lTxt += Customer.Name;
        BodyHTML_lTxt += '</td>';
        BodyHTML_lTxt += '</tr>';

        BodyHTML_lTxt += '<tr class="heading">';
        BodyHTML_lTxt += '<td>';
        BodyHTML_lTxt += 'Details:';
        BodyHTML_lTxt += '</td>';

        BodyHTML_lTxt += '<td>';
        BodyHTML_lTxt += '';
        BodyHTML_lTxt += '</td>';
        BodyHTML_lTxt += '</tr>';

        BodyHTML_lTxt += '<tr class="item">';
        BodyHTML_lTxt += '<td>';
        BodyHTML_lTxt += 'Document No.';
        BodyHTML_lTxt += '</td>';

        BodyHTML_lTxt += '<td>';
        BodyHTML_lTxt += DocumentNo_iCod;
        BodyHTML_lTxt += '</td>';
        BodyHTML_lTxt += '</tr>';

        BodyHTML_lTxt += '<tr class="item">';
        BodyHTML_lTxt += '<td>';
        BodyHTML_lTxt += 'Order Date';
        BodyHTML_lTxt += '</td>';

        BodyHTML_lTxt += '<td>';
        BodyHTML_lTxt += Format(SalesHeader_lRec."Order Date");
        BodyHTML_lTxt += '</td>';
        BodyHTML_lTxt += '</tr>';

        BodyHTML_lTxt += '<tr class="item last">';
        BodyHTML_lTxt += '<td>';
        BodyHTML_lTxt += '';
        BodyHTML_lTxt += '</td>';

        BodyHTML_lTxt += '<td>';
        BodyHTML_lTxt += '</td>';
        BodyHTML_lTxt += '</tr>';

        BodyHTML_lTxt += '<tr class="heading">';
        BodyHTML_lTxt += '<td>';
        BodyHTML_lTxt += 'Total';
        BodyHTML_lTxt += '</td>';

        BodyHTML_lTxt += '<td>';
        BodyHTML_lTxt += Format(SalesHeader_lRec."Amount Including VAT");
        BodyHTML_lTxt += '</td>';
        BodyHTML_lTxt += '</tr>';

        BodyHTML_lTxt += '</table>';
        BodyHTML_lTxt += '</div>';
        BodyHTML_lTxt += '</body>';
        BodyHTML_lTxt += '</html>';
        BodyHTML_lTxt += '<br><br>Kindly go through attached Document for more details.';
        BodyHTML_lTxt += '<br><br>Regards,<br><b>';
        BodyHTML_lTxt += CompanyInfo."Contact Person" + '<br>';
        BodyHTML_lTxt += CompanyInfo.Name + '<br>';
        BodyHTML_lTxt += CompanyInfo.Address + '<br>';
        BodyHTML_lTxt += CompanyInfo."Address 2" + '<br>';
        BodyHTML_lTxt += CompanyInfo.City + ',';
        BodyHTML_lTxt += CompanyInfo."Post Code" + '<br>';
        BodyHTML_lTxt += CompanyInfo."Phone No." + '<br>';
        BodyHTML_lTxt += CompanyInfo."E-Mail" + '<br></b>';

        WebPortalSetup_gRec.Get();
        if WebPortalSetup_gRec."Email as CC for Cust/Vend" then begin
            Clear(Recepients);
            Recepients.Add(Customer."E-Mail");
            CC.Add(Customer."E-Mail");
        end;

        EmailMessage.Create(Recepients, 'D365 Business Central', BodyHTML_lTxt, true, CC, BCC);

        XMLParameter := '<?xml version="1.0" standalone="yes"?><ReportParameters name="Order Confirmation" id="205"><Options><Field name="NoOfCopies">0</Field><Field name="ShowInternalInfo">false</Field><Field name="ArchiveDocument">false</Field><Field name="LogInteraction">true</Field><Field name="DisplayAssemblyInformation">false</Field></Options><DataItems><DataItem name="Sales Header">VERSION(1) SORTING(Field1,Field3) WHERE(Field3=1(' + SalesHeader_lRec."No." + '))</DataItem><DataItem name="CopyLoop">VERSION(1) SORTING(Field1)</DataItem><DataItem name="PageLoop">VERSION(1) SORTING(Field1)</DataItem><DataItem name="DimensionLoop1">VERSION(1) SORTING(Field1)</DataItem><DataItem name="Sales Line">VERSION(1) SORTING(Field1,Field3,Field4)</DataItem><DataItem name="RoundLoop">VERSION(1) SORTING(Field1)</DataItem><DataItem name="DimensionLoop2">VERSION(1) SORTING(Field1)</DataItem><DataItem name="AsmLoop">VERSION(1) SORTING(Field1)</DataItem><DataItem name="VATCounter">VERSION(1) SORTING(Field1)</DataItem><DataItem name="VATCounterLCY">VERSION(1) SORTING(Field1)</DataItem><DataItem name="Total">VERSION(1) SORTING(Field1)</DataItem><DataItem name="Total2">VERSION(1) SORTING(Field1)</DataItem><DataItem name="PrepmtLoop">VERSION(1) SORTING(Field1)</DataItem><DataItem name="PrepmtDimLoop">VERSION(1) SORTING(Field1)</DataItem><DataItem name="PrepmtVATCounter">VERSION(1) SORTING(Field1)</DataItem><DataItem name="PrepmtTotal">VERSION(1) SORTING(Field1)</DataItem></DataItems></ReportParameters>';
        TempBlob.CreateOutStream(EmailoutStream);
        Report.SaveAs(205, XMLParameter, ReportFormat::Pdf, EmailoutStream);
        TempBlob.CreateInStream(EmailInStream);

        EmailMessage.AddAttachment('SalesOrder' + DocumentNo_iCod + '.pdf', 'PDF', EmailInStream);

        // if SMTPMail.TrySend() then begin
        //     Message('Email Sent Successfully');
        //     exit(true);
        // end;
        Clear(Email);
        if Email.Send(EmailMessage, Enum::"Email Scenario"::Default) then begin
            if GuiAllowed then
                Message('Email Sent Successfully');
            exit(true);
        end
    end;

    procedure PrintPostedPurchDebitNote_gFnc(DocumentNo_iCod: Code[20]; UserID: Code[80]): Boolean
    var
        CompanyInfo: Record "Company Information";
        PurchCrMemoHdr_lRec: Record "Purch. Cr. Memo Hdr.";
        Vendor: Record Vendor;
        Email: Codeunit Email;
        EmailMessage: Codeunit "Email Message";
        TempBlob: Codeunit "Temp Blob";
        EmailInStream: InStream;
        BCC: List of [Text];
        CC: List of [Text];
        Recepients: List of [Text];
        EmailoutStream: OutStream;
        BodyHTML_lTxt: Text;
        XMLParameter: Text;

    begin
        PurchCrMemoHdr_lRec.Reset();
        PurchCrMemoHdr_lRec.SetRange("No.", DocumentNo_iCod);
        if not PurchCrMemoHdr_lRec.FindFirst() then
            Error('Purchase Debit Note doesnot exists with Document No. %1', DocumentNo_iCod);

        Clear(Vendor);
        Vendor.Get(PurchCrMemoHdr_lRec."Buy-from Vendor No.");

        //XMLParameter := Report.RunRequestPage(407);
        Recepients.Add(UserID);
        //SMTPMail.CreateMessage('Intech Systems Pvt. Ltd.', SMTPMailsetup."User ID", Recepients, 'D365 Business Central', '');
        Clear(CompanyInfo);
        CompanyInfo.Get();
        CompanyInfo.CalcFields(Picture);
        PurchCrMemoHdr_lRec.CalcFields("Amount Including VAT");

        BodyHTML_lTxt += '<html>';
        BodyHTML_lTxt += '<head>';
        BodyHTML_lTxt += '<meta charset="utf-8">';
        BodyHTML_lTxt += '<title>A simple, clean, and responsive HTML invoice template</title>';

        BodyHTML_lTxt += '<style>';
        BodyHTML_lTxt += '.invoice-box {';
        BodyHTML_lTxt += 'max-width: 800px;';
        BodyHTML_lTxt += 'margin: auto;';
        BodyHTML_lTxt += 'padding: 30px;';
        BodyHTML_lTxt += 'border: 1px solid #eee;';
        BodyHTML_lTxt += 'box-shadow: 0 0 10px rgba(0, 0, 0, .15;';
        BodyHTML_lTxt += 'font-size: 16px;';
        BodyHTML_lTxt += 'line-height: 24px;';
        BodyHTML_lTxt += 'font-family: ''Helvetica Neue'', ''Helvetica'', Helvetica, Arial, sans-serif;';
        BodyHTML_lTxt += 'color: #555;';
        BodyHTML_lTxt += '}';

        BodyHTML_lTxt += '.invoice-box table {';
        BodyHTML_lTxt += 'width: 100%;';
        BodyHTML_lTxt += 'line-height: inherit;';
        BodyHTML_lTxt += 'text-align: left;';
        BodyHTML_lTxt += '}';

        BodyHTML_lTxt += '.invoice-box table td {';
        BodyHTML_lTxt += 'padding: 5px;';
        BodyHTML_lTxt += 'vertical-align: top;';
        BodyHTML_lTxt += '}';

        BodyHTML_lTxt += '.invoice-box table tr td:nth-child(2) {';
        BodyHTML_lTxt += 'text-align: right;';
        BodyHTML_lTxt += '}';

        BodyHTML_lTxt += '.invoice-box table tr.top table td {';
        BodyHTML_lTxt += 'padding-bottom: 20px;';
        BodyHTML_lTxt += '}';

        BodyHTML_lTxt += '.invoice-box table tr.top table td.title {';
        BodyHTML_lTxt += 'font-size: 45px;';
        BodyHTML_lTxt += 'line-height: 45px;';
        BodyHTML_lTxt += 'color: #333;';
        BodyHTML_lTxt += '}';

        BodyHTML_lTxt += '.invoice-box table tr.information table td {';
        BodyHTML_lTxt += 'padding-bottom: 40px;';
        BodyHTML_lTxt += '}';

        BodyHTML_lTxt += '.invoice-box table tr.heading td {';
        BodyHTML_lTxt += 'background: #eee;';
        BodyHTML_lTxt += 'border-bottom: 1px solid #ddd;';
        BodyHTML_lTxt += 'font-weight: bold;';
        BodyHTML_lTxt += '}';

        BodyHTML_lTxt += '.invoice-box table tr.details td {';
        BodyHTML_lTxt += 'padding-bottom: 20px;';
        BodyHTML_lTxt += '}';

        BodyHTML_lTxt += '.invoice-box table tr.item td{';
        BodyHTML_lTxt += 'border-bottom: 1px solid #eee;';
        BodyHTML_lTxt += '}';

        BodyHTML_lTxt += '.invoice-box table tr.item.last td {';
        BodyHTML_lTxt += 'border-bottom: none;';
        BodyHTML_lTxt += '}';

        BodyHTML_lTxt += '.invoice-box table tr.total td:nth-child(2) {';
        BodyHTML_lTxt += 'border-top: 2px solid #eee;';
        BodyHTML_lTxt += 'font-weight: bold;';
        BodyHTML_lTxt += '}';

        BodyHTML_lTxt += '@media only screen and (max-width: 600px) {';
        BodyHTML_lTxt += '.invoice-box table tr.top table td {';
        BodyHTML_lTxt += 'width: 100%;';
        BodyHTML_lTxt += 'display: block;';
        BodyHTML_lTxt += 'text-align: center;';
        BodyHTML_lTxt += '}';

        BodyHTML_lTxt += '.invoice-box table tr.information table td {';
        BodyHTML_lTxt += 'width: 100%;';
        BodyHTML_lTxt += 'display: block;';
        BodyHTML_lTxt += 'text-align: center;';
        BodyHTML_lTxt += '}';
        BodyHTML_lTxt += '}';

        BodyHTML_lTxt += '/** RTL **/';
        BodyHTML_lTxt += '.rtl {';
        BodyHTML_lTxt += 'direction: rtl;';
        BodyHTML_lTxt += 'font-family: Tahoma, ''Helvetica Neue'', ''Helvetica'', Helvetica, Arial, sans-serif;';
        BodyHTML_lTxt += '}';

        BodyHTML_lTxt += '.rtl table {';
        BodyHTML_lTxt += 'text-align: right;';
        BodyHTML_lTxt += '}';

        BodyHTML_lTxt += '.rtl table tr td:nth-child(2) {';
        BodyHTML_lTxt += 'text-align: left;';
        BodyHTML_lTxt += '}';
        BodyHTML_lTxt += '</style>';
        BodyHTML_lTxt += '</head>';

        BodyHTML_lTxt += '<body>';
        BodyHTML_lTxt += '<div class="invoice-box">';
        BodyHTML_lTxt += '<table cellpadding="0" cellspacing="0">';
        BodyHTML_lTxt += '<tr class="top">';
        BodyHTML_lTxt += '<td colspan="2">';
        BodyHTML_lTxt += '<table>';
        BodyHTML_lTxt += '<tr>';
        BodyHTML_lTxt += '<td>';
        BodyHTML_lTxt += '<img src="https://106c4.wpc.azureedge.net/80106C4/Gallery-Prod/cdn/2015-02-24/prod20161101-microsoft-windowsazure-gallery/microsoftdynsmb.3a67602d-0a4f-4ae4-ad03-c1124f6ac3cf.1.0.2/Icon/large.png" height="100" width="100">';
        BodyHTML_lTxt += '</td>';

        BodyHTML_lTxt += '<td class="title">';
        BodyHTML_lTxt += '<b><font size = "5">Purchase Debit Note</font></b><br>';
        BodyHTML_lTxt += '</td>';
        BodyHTML_lTxt += '</tr>';
        BodyHTML_lTxt += '</table>';
        BodyHTML_lTxt += '</td>';
        BodyHTML_lTxt += '</tr>';

        BodyHTML_lTxt += '<tr class="information">';
        BodyHTML_lTxt += '<td colspan="2">';
        BodyHTML_lTxt += '<table>';
        BodyHTML_lTxt += '<tr>';
        BodyHTML_lTxt += '<td>';
        BodyHTML_lTxt += CompanyInfo.Name + '<br>';
        BodyHTML_lTxt += CompanyInfo.Address + '<br>';
        BodyHTML_lTxt += CompanyInfo."Address 2" + '<br>';
        BodyHTML_lTxt += CompanyInfo.City + '<br>';
        BodyHTML_lTxt += CompanyInfo."Post Code" + '<br>';
        BodyHTML_lTxt += CompanyInfo."Phone No." + '<br>';
        BodyHTML_lTxt += '</td>';

        BodyHTML_lTxt += '<td>';
        BodyHTML_lTxt += CompanyInfo."Contact Person" + '<br>';
        BodyHTML_lTxt += CompanyInfo."E-Mail" + '<br>';
        BodyHTML_lTxt += 'Created Date:' + Format(CurrentDateTime()) + '<br>';
        BodyHTML_lTxt += '</td>';
        BodyHTML_lTxt += '</tr>';
        BodyHTML_lTxt += '</table>';
        BodyHTML_lTxt += '</td>';
        BodyHTML_lTxt += '</tr>';

        BodyHTML_lTxt += '<tr class="heading">';
        BodyHTML_lTxt += '<td>';
        BodyHTML_lTxt += 'Account No.';
        BodyHTML_lTxt += '</td>';

        BodyHTML_lTxt += '<td>';
        BodyHTML_lTxt += Vendor."No.";
        BodyHTML_lTxt += '</td>';
        BodyHTML_lTxt += '</tr>';

        BodyHTML_lTxt += '<tr class="details">';
        BodyHTML_lTxt += '<td>';
        BodyHTML_lTxt += 'Name';
        BodyHTML_lTxt += '</td>';

        BodyHTML_lTxt += '<td>';
        BodyHTML_lTxt += Vendor.Name;
        BodyHTML_lTxt += '</td>';
        BodyHTML_lTxt += '</tr>';

        BodyHTML_lTxt += '<tr class="heading">';
        BodyHTML_lTxt += '<td>';
        BodyHTML_lTxt += 'Details:';
        BodyHTML_lTxt += '</td>';

        BodyHTML_lTxt += '<td>';
        BodyHTML_lTxt += '';
        BodyHTML_lTxt += '</td>';
        BodyHTML_lTxt += '</tr>';

        BodyHTML_lTxt += '<tr class="item">';
        BodyHTML_lTxt += '<td>';
        BodyHTML_lTxt += 'Document No.';
        BodyHTML_lTxt += '</td>';

        BodyHTML_lTxt += '<td>';
        BodyHTML_lTxt += DocumentNo_iCod;
        BodyHTML_lTxt += '</td>';
        BodyHTML_lTxt += '</tr>';

        BodyHTML_lTxt += '<tr class="item">';
        BodyHTML_lTxt += '<td>';
        BodyHTML_lTxt += 'Order Date';
        BodyHTML_lTxt += '</td>';

        BodyHTML_lTxt += '<td>';
        BodyHTML_lTxt += Format(PurchCrMemoHdr_lRec."Posting Date");
        BodyHTML_lTxt += '</td>';
        BodyHTML_lTxt += '</tr>';

        BodyHTML_lTxt += '<tr class="item last">';
        BodyHTML_lTxt += '<td>';
        BodyHTML_lTxt += '';
        BodyHTML_lTxt += '</td>';

        BodyHTML_lTxt += '<td>';
        BodyHTML_lTxt += '</td>';
        BodyHTML_lTxt += '</tr>';

        BodyHTML_lTxt += '<tr class="heading">';
        BodyHTML_lTxt += '<td>';
        BodyHTML_lTxt += 'Total';
        BodyHTML_lTxt += '</td>';

        BodyHTML_lTxt += '<td>';
        BodyHTML_lTxt += Format(PurchCrMemoHdr_lRec."Amount Including VAT");
        BodyHTML_lTxt += '</td>';
        BodyHTML_lTxt += '</tr>';

        BodyHTML_lTxt += '</table>';
        BodyHTML_lTxt += '</div>';
        BodyHTML_lTxt += '</body>';
        BodyHTML_lTxt += '</html>';
        BodyHTML_lTxt += '<br><br>Kindly go through attached Document for more details.';
        BodyHTML_lTxt += '<br><br>Regards,<br><b>';
        BodyHTML_lTxt += CompanyInfo."Contact Person" + '<br>';
        BodyHTML_lTxt += CompanyInfo.Name + '<br>';
        BodyHTML_lTxt += CompanyInfo.Address + '<br>';
        BodyHTML_lTxt += CompanyInfo."Address 2" + '<br>';
        BodyHTML_lTxt += CompanyInfo.City + ',';
        BodyHTML_lTxt += CompanyInfo."Post Code" + '<br>';
        BodyHTML_lTxt += CompanyInfo."Phone No." + '<br>';
        BodyHTML_lTxt += CompanyInfo."E-Mail" + '<br></b>';

        WebPortalSetup_gRec.Get();
        if WebPortalSetup_gRec."Email as CC for Cust/Vend" then begin
            Clear(Recepients);
            Recepients.Add(Vendor."E-Mail");
            CC.Add(Vendor."E-Mail");
        end;

        EmailMessage.Create(Recepients, 'D365 Business Central', BodyHTML_lTxt, true, CC, BCC);

        XMLParameter := '<?xml version="1.0" standalone="yes"?><ReportParameters name="Purchase - Credit Memo" id="407"><Options><Field name="NoOfCopies">0</Field><Field name="ShowInternalInfo">false</Field><Field name="LogInteraction">true</Field></Options><DataItems><DataItem name="Purch. Cr. Memo Hdr.">VERSION(1) SORTING(Field3) WHERE(Field3=1(' + PurchCrMemoHdr_lRec."No." + '))</DataItem><DataItem name="CopyLoop">VERSION(1) SORTING(Field1)</DataItem><DataItem name="PageLoop">VERSION(1) SORTING(Field1)</DataItem><DataItem name="DimensionLoop1">VERSION(1) SORTING(Field1)</DataItem><DataItem name="Purch. Cr. Memo Line">VERSION(1) SORTING(Field3,Field4)</DataItem><DataItem name="DimensionLoop2">VERSION(1) SORTING(Field1)</DataItem><DataItem name="VATCounter">VERSION(1) SORTING(Field1)</DataItem><DataItem name="VATCounterLCY">VERSION(1) SORTING(Field1)</DataItem><DataItem name="Total">VERSION(1) SORTING(Field1)</DataItem><DataItem name="Total2">VERSION(1) SORTING(Field1)</DataItem></DataItems></ReportParameters>';
        TempBlob.CreateOutStream(EmailoutStream);
        Report.SaveAs(407, XMLParameter, ReportFormat::Pdf, EmailoutStream);
        TempBlob.CreateInStream(EmailInStream);
        Emailmessage.AddAttachment('PurchaseDebitNote' + DocumentNo_iCod + '.pdf', 'PDF', EmailInStream);

        // if SMTPMail.TrySend() then begin
        //     Message('Email Sent Successfully');
        //     exit(true);
        // end;
        Clear(Email);
        if Email.Send(EmailMessage, Enum::"Email Scenario"::Default) then begin
            if GuiAllowed then
                Message('Email Sent Successfully');
            exit(true);
        end;
    end;

    procedure PrintPurchaseOrder_gFnc(DocumentNo_iCod: Code[20]; UserID: Code[80]): Boolean
    var
        CompanyInfo: Record "Company Information";
        PurchaseHeader_lRec: Record "Purchase Header";
        Vendor: Record Vendor;
        Email: Codeunit Email;
        EmailMessage: Codeunit "Email Message";
        TempBlob: Codeunit "Temp Blob";
        EmailInStream: InStream;
        BCC: List of [Text];
        CC: List of [Text];
        Recepients: List of [Text];
        EmailoutStream: OutStream;
        BodyHTML_lTxt: Text;
        XMLParameter: Text;

    begin
        PurchaseHeader_lRec.Reset();
        PurchaseHeader_lRec.SetRange("Document Type", PurchaseHeader_lRec."Document Type"::Order);
        PurchaseHeader_lRec.SetRange("No.", DocumentNo_iCod);
        if not PurchaseHeader_lRec.FindFirst() then
            Error('Purchase Order doesnot exists with Document No. %1', DocumentNo_iCod);

        Clear(Vendor);
        Vendor.Get(PurchaseHeader_lRec."Buy-from Vendor No.");

        //XMLParameter := Report.RunRequestPage(405);

        Recepients.Add(UserID);
        //SMTPMail.CreateMessage('Intech Systems Pvt. Ltd.', SMTPMailsetup."User ID", Recepients, 'D365 Business Central', '');
        Clear(CompanyInfo);
        CompanyInfo.Get();
        CompanyInfo.CalcFields(Picture);
        PurchaseHeader_lRec.CalcFields("Amount Including VAT");

        BodyHTML_lTxt += '<html>';
        BodyHTML_lTxt += '<head>';
        BodyHTML_lTxt += '<meta charset="utf-8">';
        BodyHTML_lTxt += '<title>A simple, clean, and responsive HTML invoice template</title>';

        BodyHTML_lTxt += '<style>';
        BodyHTML_lTxt += '.invoice-box {';
        BodyHTML_lTxt += 'max-width: 800px;';
        BodyHTML_lTxt += 'margin: auto;';
        BodyHTML_lTxt += 'padding: 30px;';
        BodyHTML_lTxt += 'border: 1px solid #eee;';
        BodyHTML_lTxt += 'box-shadow: 0 0 10px rgba(0, 0, 0, .15;';
        BodyHTML_lTxt += 'font-size: 16px;';
        BodyHTML_lTxt += 'line-height: 24px;';
        BodyHTML_lTxt += 'font-family: ''Helvetica Neue'', ''Helvetica'', Helvetica, Arial, sans-serif;';
        BodyHTML_lTxt += 'color: #555;';
        BodyHTML_lTxt += '}';

        BodyHTML_lTxt += '.invoice-box table {';
        BodyHTML_lTxt += 'width: 100%;';
        BodyHTML_lTxt += 'line-height: inherit;';
        BodyHTML_lTxt += 'text-align: left;';
        BodyHTML_lTxt += '}';

        BodyHTML_lTxt += '.invoice-box table td {';
        BodyHTML_lTxt += 'padding: 5px;';
        BodyHTML_lTxt += 'vertical-align: top;';
        BodyHTML_lTxt += '}';

        BodyHTML_lTxt += '.invoice-box table tr td:nth-child(2) {';
        BodyHTML_lTxt += 'text-align: right;';
        BodyHTML_lTxt += '}';

        BodyHTML_lTxt += '.invoice-box table tr.top table td {';
        BodyHTML_lTxt += 'padding-bottom: 20px;';
        BodyHTML_lTxt += '}';

        BodyHTML_lTxt += '.invoice-box table tr.top table td.title {';
        BodyHTML_lTxt += 'font-size: 45px;';
        BodyHTML_lTxt += 'line-height: 45px;';
        BodyHTML_lTxt += 'color: #333;';
        BodyHTML_lTxt += '}';

        BodyHTML_lTxt += '.invoice-box table tr.information table td {';
        BodyHTML_lTxt += 'padding-bottom: 40px;';
        BodyHTML_lTxt += '}';

        BodyHTML_lTxt += '.invoice-box table tr.heading td {';
        BodyHTML_lTxt += 'background: #eee;';
        BodyHTML_lTxt += 'border-bottom: 1px solid #ddd;';
        BodyHTML_lTxt += 'font-weight: bold;';
        BodyHTML_lTxt += '}';

        BodyHTML_lTxt += '.invoice-box table tr.details td {';
        BodyHTML_lTxt += 'padding-bottom: 20px;';
        BodyHTML_lTxt += '}';

        BodyHTML_lTxt += '.invoice-box table tr.item td{';
        BodyHTML_lTxt += 'border-bottom: 1px solid #eee;';
        BodyHTML_lTxt += '}';

        BodyHTML_lTxt += '.invoice-box table tr.item.last td {';
        BodyHTML_lTxt += 'border-bottom: none;';
        BodyHTML_lTxt += '}';

        BodyHTML_lTxt += '.invoice-box table tr.total td:nth-child(2) {';
        BodyHTML_lTxt += 'border-top: 2px solid #eee;';
        BodyHTML_lTxt += 'font-weight: bold;';
        BodyHTML_lTxt += '}';

        BodyHTML_lTxt += '@media only screen and (max-width: 600px) {';
        BodyHTML_lTxt += '.invoice-box table tr.top table td {';
        BodyHTML_lTxt += 'width: 100%;';
        BodyHTML_lTxt += 'display: block;';
        BodyHTML_lTxt += 'text-align: center;';
        BodyHTML_lTxt += '}';

        BodyHTML_lTxt += '.invoice-box table tr.information table td {';
        BodyHTML_lTxt += 'width: 100%;';
        BodyHTML_lTxt += 'display: block;';
        BodyHTML_lTxt += 'text-align: center;';
        BodyHTML_lTxt += '}';
        BodyHTML_lTxt += '}';

        BodyHTML_lTxt += '/** RTL **/';
        BodyHTML_lTxt += '.rtl {';
        BodyHTML_lTxt += 'direction: rtl;';
        BodyHTML_lTxt += 'font-family: Tahoma, ''Helvetica Neue'', ''Helvetica'', Helvetica, Arial, sans-serif;';
        BodyHTML_lTxt += '}';

        BodyHTML_lTxt += '.rtl table {';
        BodyHTML_lTxt += 'text-align: right;';
        BodyHTML_lTxt += '}';

        BodyHTML_lTxt += '.rtl table tr td:nth-child(2) {';
        BodyHTML_lTxt += 'text-align: left;';
        BodyHTML_lTxt += '}';
        BodyHTML_lTxt += '</style>';
        BodyHTML_lTxt += '</head>';

        BodyHTML_lTxt += '<body>';
        BodyHTML_lTxt += '<div class="invoice-box">';
        BodyHTML_lTxt += '<table cellpadding="0" cellspacing="0">';
        BodyHTML_lTxt += '<tr class="top">';
        BodyHTML_lTxt += '<td colspan="2">';
        BodyHTML_lTxt += '<table>';
        BodyHTML_lTxt += '<tr>';
        BodyHTML_lTxt += '<td>';
        BodyHTML_lTxt += '<img src="https://106c4.wpc.azureedge.net/80106C4/Gallery-Prod/cdn/2015-02-24/prod20161101-microsoft-windowsazure-gallery/microsoftdynsmb.3a67602d-0a4f-4ae4-ad03-c1124f6ac3cf.1.0.2/Icon/large.png" height="100" width="100">';
        BodyHTML_lTxt += '</td>';

        BodyHTML_lTxt += '<td class="title">';
        BodyHTML_lTxt += '<b><font size = "5">Purchase Order</font></b><br>';
        BodyHTML_lTxt += '</td>';
        BodyHTML_lTxt += '</tr>';
        BodyHTML_lTxt += '</table>';
        BodyHTML_lTxt += '</td>';
        BodyHTML_lTxt += '</tr>';

        BodyHTML_lTxt += '<tr class="information">';
        BodyHTML_lTxt += '<td colspan="2">';
        BodyHTML_lTxt += '<table>';
        BodyHTML_lTxt += '<tr>';
        BodyHTML_lTxt += '<td>';
        BodyHTML_lTxt += CompanyInfo.Name + '<br>';
        BodyHTML_lTxt += CompanyInfo.Address + '<br>';
        BodyHTML_lTxt += CompanyInfo."Address 2" + '<br>';
        BodyHTML_lTxt += CompanyInfo.City + '<br>';
        BodyHTML_lTxt += CompanyInfo."Post Code" + '<br>';
        BodyHTML_lTxt += CompanyInfo."Phone No." + '<br>';
        BodyHTML_lTxt += '</td>';

        BodyHTML_lTxt += '<td>';
        BodyHTML_lTxt += CompanyInfo."Contact Person" + '<br>';
        BodyHTML_lTxt += CompanyInfo."E-Mail" + '<br>';
        BodyHTML_lTxt += 'Created Date:' + Format(CurrentDateTime()) + '<br>';
        BodyHTML_lTxt += '</td>';
        BodyHTML_lTxt += '</tr>';
        BodyHTML_lTxt += '</table>';
        BodyHTML_lTxt += '</td>';
        BodyHTML_lTxt += '</tr>';

        BodyHTML_lTxt += '<tr class="heading">';
        BodyHTML_lTxt += '<td>';
        BodyHTML_lTxt += 'Account No.';
        BodyHTML_lTxt += '</td>';

        BodyHTML_lTxt += '<td>';
        BodyHTML_lTxt += Vendor."No.";
        BodyHTML_lTxt += '</td>';
        BodyHTML_lTxt += '</tr>';

        BodyHTML_lTxt += '<tr class="details">';
        BodyHTML_lTxt += '<td>';
        BodyHTML_lTxt += 'Name';
        BodyHTML_lTxt += '</td>';

        BodyHTML_lTxt += '<td>';
        BodyHTML_lTxt += Vendor.Name;
        BodyHTML_lTxt += '</td>';
        BodyHTML_lTxt += '</tr>';

        BodyHTML_lTxt += '<tr class="heading">';
        BodyHTML_lTxt += '<td>';
        BodyHTML_lTxt += 'Details:';
        BodyHTML_lTxt += '</td>';

        BodyHTML_lTxt += '<td>';
        BodyHTML_lTxt += '';
        BodyHTML_lTxt += '</td>';
        BodyHTML_lTxt += '</tr>';

        BodyHTML_lTxt += '<tr class="item">';
        BodyHTML_lTxt += '<td>';
        BodyHTML_lTxt += 'Document No.';
        BodyHTML_lTxt += '</td>';

        BodyHTML_lTxt += '<td>';
        BodyHTML_lTxt += DocumentNo_iCod;
        BodyHTML_lTxt += '</td>';
        BodyHTML_lTxt += '</tr>';

        BodyHTML_lTxt += '<tr class="item">';
        BodyHTML_lTxt += '<td>';
        BodyHTML_lTxt += 'Order Date';
        BodyHTML_lTxt += '</td>';

        BodyHTML_lTxt += '<td>';
        BodyHTML_lTxt += Format(PurchaseHeader_lRec."Order Date");
        BodyHTML_lTxt += '</td>';
        BodyHTML_lTxt += '</tr>';

        BodyHTML_lTxt += '<tr class="item last">';
        BodyHTML_lTxt += '<td>';
        BodyHTML_lTxt += '';
        BodyHTML_lTxt += '</td>';

        BodyHTML_lTxt += '<td>';
        BodyHTML_lTxt += '</td>';
        BodyHTML_lTxt += '</tr>';

        BodyHTML_lTxt += '<tr class="heading">';
        BodyHTML_lTxt += '<td>';
        BodyHTML_lTxt += 'Total';
        BodyHTML_lTxt += '</td>';

        BodyHTML_lTxt += '<td>';
        BodyHTML_lTxt += Format(PurchaseHeader_lRec."Amount Including VAT");
        BodyHTML_lTxt += '</td>';
        BodyHTML_lTxt += '</tr>';

        BodyHTML_lTxt += '</table>';
        BodyHTML_lTxt += '</div>';
        BodyHTML_lTxt += '</body>';
        BodyHTML_lTxt += '</html>';
        BodyHTML_lTxt += '<br><br>Kindly go through attached Document for more details.';
        BodyHTML_lTxt += '<br><br>Regards,<br><b>';
        BodyHTML_lTxt += CompanyInfo."Contact Person" + '<br>';
        BodyHTML_lTxt += CompanyInfo.Name + '<br>';
        BodyHTML_lTxt += CompanyInfo.Address + '<br>';
        BodyHTML_lTxt += CompanyInfo."Address 2" + '<br>';
        BodyHTML_lTxt += CompanyInfo.City + ',';
        BodyHTML_lTxt += CompanyInfo."Post Code" + '<br>';
        BodyHTML_lTxt += CompanyInfo."Phone No." + '<br>';
        BodyHTML_lTxt += CompanyInfo."E-Mail" + '<br></b>';

        WebPortalSetup_gRec.Get();
        if WebPortalSetup_gRec."Email as CC for Cust/Vend" then begin
            Clear(Recepients);
            Recepients.Add(Vendor."E-Mail");
            CC.Add(Vendor."E-Mail");
        end;

        EmailMessage.Create(Recepients, 'D365 Business Central', BodyHTML_lTxt, true, CC, BCC);

        XMLParameter := '<?xml version="1.0" standalone="yes"?><ReportParameters name="Order" id="405"><Options><Field name="NoOfCopies">0</Field><Field name="ShowInternalInfo">false</Field><Field name="ArchiveDocument">false</Field><Field name="LogInteraction">true</Field></Options><DataItems><DataItem name="Purchase Header">VERSION(1) SORTING(Field1,Field3) WHERE(Field3=1(' + PurchaseHeader_lRec."No." + '))</DataItem><DataItem name="CopyLoop">VERSION(1) SORTING(Field1)</DataItem><DataItem name="PageLoop">VERSION(1) SORTING(Field1)</DataItem><DataItem name="DimensionLoop1">VERSION(1) SORTING(Field1)</DataItem><DataItem name="Purchase Line">VERSION(1) SORTING(Field1,Field3,Field4)</DataItem><DataItem name="RoundLoop">VERSION(1) SORTING(Field1)</DataItem><DataItem name="DimensionLoop2">VERSION(1) SORTING(Field1)</DataItem><DataItem name="VATCounter">VERSION(1) SORTING(Field1)</DataItem><DataItem name="VATCounterLCY">VERSION(1) SORTING(Field1)</DataItem><DataItem name="Total">VERSION(1) SORTING(Field1)</DataItem><DataItem name="Total2">VERSION(1) SORTING(Field1)</DataItem><DataItem name="Total3">VERSION(1) SORTING(Field1)</DataItem><DataItem name="PrepmtLoop">VERSION(1) SORTING(Field1)</DataItem><DataItem name="PrepmtDimLoop">VERSION(1) SORTING(Field1)</DataItem><DataItem name="PrepmtVATCounter">VERSION(1) SORTING(Field1)</DataItem></DataItems></ReportParameters>';
        TempBlob.CreateOutStream(EmailoutStream);
        Report.SaveAs(405, XMLParameter, ReportFormat::Pdf, EmailoutStream);
        TempBlob.CreateInStream(EmailInStream);
        EmailMessage.AddAttachment('PurchaseOrder' + DocumentNo_iCod + '.pdf', 'PDF', EmailInStream);

        // if SMTPMail.TrySend() then begin
        //     Message('Email Sent Successfully');
        //     exit(true);
        // end;
        Clear(Email);
        if Email.Send(EmailMessage, Enum::"Email Scenario"::Default) then begin
            if GuiAllowed then
                Message('Email Sent Successfully');
            exit(true);
        end
    end;

    procedure PrintCustomerStatement_gFnc(CustomerNo_iCod: Code[20]; StateDate_iTxt: Text[20]; EndDate_iTxt: Text[20]; UserID: Code[80]): Boolean
    var
        CompanyInfo: Record "Company Information";
        Customer_lRec: Record Customer;
        CustomerLedgerReport: Report "INT Customer Ledger";
        Email: Codeunit Email;
        EmailMessage: Codeunit "Email Message";
        TempBlob: Codeunit "Temp Blob";
        ConvertedEndDate: Date;
        ConvertedStartDate: Date;
        EmailInStream: InStream;
        DD: Integer;
        MM: Integer;
        YYYY: Integer;
        BCC: List of [Text];
        CC: List of [Text];
        Recepients: List of [Text];
        EmailoutStream: OutStream;
        BodyHTML_lTxt: Text;
        XMLParameter: Text;
    begin
        if StateDate_iTxt = '' then
            Error('Please select the Start Date');

        if EndDate_iTxt = '' then
            Error('Please select the End Date');

        ConvertedStartDate := 0D;
        MM := 0;
        DD := 0;
        YYYY := 0;
        Evaluate(MM, CopyStr(StateDate_iTxt, 1, 2));
        Evaluate(DD, CopyStr(StateDate_iTxt, 4, 2));
        Evaluate(YYYY, CopyStr(StateDate_iTxt, 7, 4));

        ConvertedStartDate := DMY2Date(DD, MM, YYYY);

        ConvertedEndDate := 0D;
        MM := 0;
        DD := 0;
        YYYY := 0;
        Evaluate(MM, CopyStr(EndDate_iTxt, 1, 2));
        Evaluate(DD, CopyStr(EndDate_iTxt, 4, 2));
        Evaluate(YYYY, CopyStr(EndDate_iTxt, 7, 4));

        ConvertedEndDate := DMY2Date(DD, MM, YYYY);

        Customer_lRec.Reset();
        Customer_lRec.SetRange("No.", CustomerNo_iCod);
        Customer_lRec.SetFilter("Date Filter", '%1..%2', ConvertedStartDate, ConvertedEndDate);
        if not Customer_lRec.FindFirst() then
            Error('Statement from Date %1 to %2 doesnot exists.', ConvertedStartDate, ConvertedEndDate);

        //XMLParameter := Report.RunRequestPage(70144598);
        Recepients.Add(UserID);
        //SMTPMail.CreateMessage('Intech Systems Pvt. Ltd.', SMTPMailsetup."User ID", Recepients, 'D365 Business Central', '');

        Clear(CompanyInfo);
        CompanyInfo.Get();
        CompanyInfo.CalcFields(Picture);
        //Customer_lRec.CalcFields("Amount Including VAT");


        BodyHTML_lTxt += '<html>';
        BodyHTML_lTxt += '<head>';
        BodyHTML_lTxt += '<meta charset="utf-8">';
        BodyHTML_lTxt += '<title>A simple, clean, and responsive HTML invoice template</title>';

        BodyHTML_lTxt += '<style>';
        BodyHTML_lTxt += '.invoice-box {';
        BodyHTML_lTxt += 'max-width: 800px;';
        BodyHTML_lTxt += 'margin: auto;';
        BodyHTML_lTxt += 'padding: 30px;';
        BodyHTML_lTxt += 'border: 1px solid #eee;';
        BodyHTML_lTxt += 'box-shadow: 0 0 10px rgba(0, 0, 0, .15;';
        BodyHTML_lTxt += 'font-size: 16px;';
        BodyHTML_lTxt += 'line-height: 24px;';
        BodyHTML_lTxt += 'font-family: ''Helvetica Neue'', ''Helvetica'', Helvetica, Arial, sans-serif;';
        BodyHTML_lTxt += 'color: #555;';
        BodyHTML_lTxt += '}';

        BodyHTML_lTxt += '.invoice-box table {';
        BodyHTML_lTxt += 'width: 100%;';
        BodyHTML_lTxt += 'line-height: inherit;';
        BodyHTML_lTxt += 'text-align: left;';
        BodyHTML_lTxt += '}';

        BodyHTML_lTxt += '.invoice-box table td {';
        BodyHTML_lTxt += 'padding: 5px;';
        BodyHTML_lTxt += 'vertical-align: top;';
        BodyHTML_lTxt += '}';

        BodyHTML_lTxt += '.invoice-box table tr td:nth-child(2) {';
        BodyHTML_lTxt += 'text-align: right;';
        BodyHTML_lTxt += '}';

        BodyHTML_lTxt += '.invoice-box table tr.top table td {';
        BodyHTML_lTxt += 'padding-bottom: 20px;';
        BodyHTML_lTxt += '}';

        BodyHTML_lTxt += '.invoice-box table tr.top table td.title {';
        BodyHTML_lTxt += 'font-size: 45px;';
        BodyHTML_lTxt += 'line-height: 45px;';
        BodyHTML_lTxt += 'color: #333;';
        BodyHTML_lTxt += '}';

        BodyHTML_lTxt += '.invoice-box table tr.information table td {';
        BodyHTML_lTxt += 'padding-bottom: 40px;';
        BodyHTML_lTxt += '}';

        BodyHTML_lTxt += '.invoice-box table tr.heading td {';
        BodyHTML_lTxt += 'background: #eee;';
        BodyHTML_lTxt += 'border-bottom: 1px solid #ddd;';
        BodyHTML_lTxt += 'font-weight: bold;';
        BodyHTML_lTxt += '}';

        BodyHTML_lTxt += '.invoice-box table tr.details td {';
        BodyHTML_lTxt += 'padding-bottom: 20px;';
        BodyHTML_lTxt += '}';

        BodyHTML_lTxt += '.invoice-box table tr.item td{';
        BodyHTML_lTxt += 'border-bottom: 1px solid #eee;';
        BodyHTML_lTxt += '}';

        BodyHTML_lTxt += '.invoice-box table tr.item.last td {';
        BodyHTML_lTxt += 'border-bottom: none;';
        BodyHTML_lTxt += '}';

        BodyHTML_lTxt += '.invoice-box table tr.total td:nth-child(2) {';
        BodyHTML_lTxt += 'border-top: 2px solid #eee;';
        BodyHTML_lTxt += 'font-weight: bold;';
        BodyHTML_lTxt += '}';

        BodyHTML_lTxt += '@media only screen and (max-width: 600px) {';
        BodyHTML_lTxt += '.invoice-box table tr.top table td {';
        BodyHTML_lTxt += 'width: 100%;';
        BodyHTML_lTxt += 'display: block;';
        BodyHTML_lTxt += 'text-align: center;';
        BodyHTML_lTxt += '}';

        BodyHTML_lTxt += '.invoice-box table tr.information table td {';
        BodyHTML_lTxt += 'width: 100%;';
        BodyHTML_lTxt += 'display: block;';
        BodyHTML_lTxt += 'text-align: center;';
        BodyHTML_lTxt += '}';
        BodyHTML_lTxt += '}';

        BodyHTML_lTxt += '/** RTL **/';
        BodyHTML_lTxt += '.rtl {';
        BodyHTML_lTxt += 'direction: rtl;';
        BodyHTML_lTxt += 'font-family: Tahoma, ''Helvetica Neue'', ''Helvetica'', Helvetica, Arial, sans-serif;';
        BodyHTML_lTxt += '}';

        BodyHTML_lTxt += '.rtl table {';
        BodyHTML_lTxt += 'text-align: right;';
        BodyHTML_lTxt += '}';

        BodyHTML_lTxt += '.rtl table tr td:nth-child(2) {';
        BodyHTML_lTxt += 'text-align: left;';
        BodyHTML_lTxt += '}';
        BodyHTML_lTxt += '</style>';
        BodyHTML_lTxt += '</head>';

        BodyHTML_lTxt += '<body>';
        BodyHTML_lTxt += '<div class="invoice-box">';
        BodyHTML_lTxt += '<table cellpadding="0" cellspacing="0">';
        BodyHTML_lTxt += '<tr class="top">';
        BodyHTML_lTxt += '<td colspan="2">';
        BodyHTML_lTxt += '<table>';
        BodyHTML_lTxt += '<tr>';
        BodyHTML_lTxt += '<td>';
        BodyHTML_lTxt += '<img src="https://106c4.wpc.azureedge.net/80106C4/Gallery-Prod/cdn/2015-02-24/prod20161101-microsoft-windowsazure-gallery/microsoftdynsmb.3a67602d-0a4f-4ae4-ad03-c1124f6ac3cf.1.0.2/Icon/large.png" height="100" width="100">';
        BodyHTML_lTxt += '</td>';

        BodyHTML_lTxt += '<td class="title">';
        BodyHTML_lTxt += '<b><font size = "5">Customer Statement</font></b><br>';
        BodyHTML_lTxt += '</td>';
        BodyHTML_lTxt += '</tr>';
        BodyHTML_lTxt += '</table>';
        BodyHTML_lTxt += '</td>';
        BodyHTML_lTxt += '</tr>';

        BodyHTML_lTxt += '<tr class="information">';
        BodyHTML_lTxt += '<td colspan="2">';
        BodyHTML_lTxt += '<table>';
        BodyHTML_lTxt += '<tr>';
        BodyHTML_lTxt += '<td>';
        BodyHTML_lTxt += CompanyInfo.Name + '<br>';
        BodyHTML_lTxt += CompanyInfo.Address + '<br>';
        BodyHTML_lTxt += CompanyInfo."Address 2" + '<br>';
        BodyHTML_lTxt += CompanyInfo.City + '<br>';
        BodyHTML_lTxt += CompanyInfo."Post Code" + '<br>';
        BodyHTML_lTxt += CompanyInfo."Phone No." + '<br>';
        BodyHTML_lTxt += '</td>';

        BodyHTML_lTxt += '<td>';
        BodyHTML_lTxt += CompanyInfo."Contact Person" + '<br>';
        BodyHTML_lTxt += CompanyInfo."E-Mail" + '<br>';
        BodyHTML_lTxt += 'Created Date:' + Format(CurrentDateTime()) + '<br>';
        BodyHTML_lTxt += '</td>';
        BodyHTML_lTxt += '</tr>';
        BodyHTML_lTxt += '</table>';
        BodyHTML_lTxt += '</td>';
        BodyHTML_lTxt += '</tr>';

        BodyHTML_lTxt += '<tr class="heading">';
        BodyHTML_lTxt += '<td>';
        BodyHTML_lTxt += 'Account No.';
        BodyHTML_lTxt += '</td>';

        BodyHTML_lTxt += '<td>';
        BodyHTML_lTxt += Customer_lRec."No.";
        BodyHTML_lTxt += '</td>';
        BodyHTML_lTxt += '</tr>';

        BodyHTML_lTxt += '<tr class="details">';
        BodyHTML_lTxt += '<td>';
        BodyHTML_lTxt += 'Name';
        BodyHTML_lTxt += '</td>';

        BodyHTML_lTxt += '<td>';
        BodyHTML_lTxt += Customer_lRec.Name;
        BodyHTML_lTxt += '</td>';
        BodyHTML_lTxt += '</tr>';

        BodyHTML_lTxt += '<tr class="heading">';
        BodyHTML_lTxt += '<td>';
        BodyHTML_lTxt += 'Details:';
        BodyHTML_lTxt += '</td>';

        BodyHTML_lTxt += '<td>';
        BodyHTML_lTxt += '';
        BodyHTML_lTxt += '</td>';
        BodyHTML_lTxt += '</tr>';

        BodyHTML_lTxt += '<tr class="item">';
        BodyHTML_lTxt += '<td>';
        BodyHTML_lTxt += 'Period';
        BodyHTML_lTxt += '</td>';

        BodyHTML_lTxt += '<td>';
        BodyHTML_lTxt += 'From ' + Format(ConvertedStartDate) + ' To ' + Format(ConvertedEndDate);
        BodyHTML_lTxt += '</td>';
        BodyHTML_lTxt += '</tr>';

        BodyHTML_lTxt += '<tr class="item last">';
        BodyHTML_lTxt += '<td>';
        BodyHTML_lTxt += '';
        BodyHTML_lTxt += '</td>';

        BodyHTML_lTxt += '<td>';
        BodyHTML_lTxt += '</td>';
        BodyHTML_lTxt += '</tr>';

        BodyHTML_lTxt += '</table>';
        BodyHTML_lTxt += '</div>';
        BodyHTML_lTxt += '</body>';
        BodyHTML_lTxt += '</html>';
        BodyHTML_lTxt += '<br><br>Kindly go through attached Document for more details.';
        BodyHTML_lTxt += '<br><br>Regards,<br><b>';
        BodyHTML_lTxt += CompanyInfo."Contact Person" + '<br>';
        BodyHTML_lTxt += CompanyInfo.Name + '<br>';
        BodyHTML_lTxt += CompanyInfo.Address + '<br>';
        BodyHTML_lTxt += CompanyInfo."Address 2" + '<br>';
        BodyHTML_lTxt += CompanyInfo.City + ',';
        BodyHTML_lTxt += CompanyInfo."Post Code" + '<br>';
        BodyHTML_lTxt += CompanyInfo."Phone No." + '<br>';
        BodyHTML_lTxt += CompanyInfo."E-Mail" + '<br></b>';

        WebPortalSetup_gRec.Get();
        if WebPortalSetup_gRec."Email as CC for Cust/Vend" then begin
            Clear(Recepients);
            Recepients.Add(Customer_lRec."E-Mail");
            CC.Add(Customer_lRec."E-Mail");
        end;
        EmailMessage.Create(Recepients, 'D365 Business Central', BodyHTML_lTxt, true, CC, BCC);

        XMLParameter := '<?xml version="1.0" standalone="yes"?><ReportParameters name="Customer Ledger" id="70144598"><Options><Field name="ShowAmtInLCY_gBln">false</Field><Field name="SortByName_gBln">false</Field></Options><DataItems><DataItem name="Customer">VERSION(1) SORTING(Field1) WHERE(Field1=1(' + Customer_lRec."No." + '),Field55=1())</DataItem><DataItem name="Detailed Cust. Ledg. Entry">VERSION(1) SORTING(Field9,Field4,Field6)</DataItem><DataItem name="G/L Entry">VERSION(1) SORTING(Field3,Field4)</DataItem></DataItems></ReportParameters>';

        TempBlob.CreateOutStream(EmailoutStream);
        Clear(CustomerLedgerReport);
        CustomerLedgerReport.SetParameter(ConvertedStartDate, ConvertedEndDate);
        CustomerLedgerReport.SaveAs(XMLParameter, ReportFormat::Pdf, EmailoutStream);
        TempBlob.CreateInStream(EmailInStream);
        EmailMessage.AddAttachment('CustomerStatement' + CustomerNo_iCod + '.pdf', 'PDF', EmailInStream);

        // if SMTPMail.TrySend() then begin
        //     Message('Email Sent Successfully');
        //     exit(true);
        // end;
        Clear(Email);
        if Email.Send(EmailMessage, Enum::"Email Scenario"::Default) then begin
            if GuiAllowed then
                Message('Email Sent Successfully');
            exit(true);
        end;
    end;

    procedure PrintCustomerStatementEXCEL_gFnc(CustomerNo_iCod: Code[20]; StateDate_iTxt: Text[20]; EndDate_iTxt: Text[20]; UserID: Code[80]): Boolean
    var
        CompanyInfo: Record "Company Information";
        Customer_lRec: Record Customer;
        CustomerLedgerReport: Report "INT Customer Ledger";
        Email: Codeunit Email;
        EmailMessage: Codeunit "Email Message";
        TempBlob: Codeunit "Temp Blob";
        ConvertedEndDate: Date;
        ConvertedStartDate: Date;
        EmailInStream: InStream;
        DD: Integer;
        MM: Integer;
        YYYY: Integer;
        BCC: List of [Text];
        CC: List of [Text];
        Recepients: List of [Text];
        EmailoutStream: OutStream;
        BodyHTML_lTxt: Text;
        XMLParameter: Text;
    begin
        if StateDate_iTxt = '' then
            Error('Please select the Start Date');

        if EndDate_iTxt = '' then
            Error('Please select the End Date');


        ConvertedStartDate := 0D;
        MM := 0;
        DD := 0;
        YYYY := 0;
        Evaluate(MM, CopyStr(StateDate_iTxt, 1, 2));
        Evaluate(DD, CopyStr(StateDate_iTxt, 4, 2));
        Evaluate(YYYY, CopyStr(StateDate_iTxt, 7, 4));

        ConvertedStartDate := DMY2Date(DD, MM, YYYY);

        ConvertedEndDate := 0D;
        MM := 0;
        DD := 0;
        YYYY := 0;
        Evaluate(MM, CopyStr(EndDate_iTxt, 1, 2));
        Evaluate(DD, CopyStr(EndDate_iTxt, 4, 2));
        Evaluate(YYYY, CopyStr(EndDate_iTxt, 7, 4));

        ConvertedEndDate := DMY2Date(DD, MM, YYYY);

        Customer_lRec.Reset();
        Customer_lRec.SetRange("No.", CustomerNo_iCod);
        Customer_lRec.SetFilter("Date Filter", '%1..%2', ConvertedStartDate, ConvertedEndDate);
        if not Customer_lRec.FindFirst() then
            Error('Statement from Date %1 to %2 doesnot exists.', ConvertedStartDate, ConvertedEndDate);

        //XMLParameter := Report.RunRequestPage(70144598);
        Clear(Recepients);
        Recepients.Add(UserID);
        //SMTPMail.CreateMessage('Intech Systems Pvt. Ltd.', SMTPMailsetup."User ID", Recepients, 'D365 Business Central', '');

        Clear(CompanyInfo);
        CompanyInfo.Get();
        CompanyInfo.CalcFields(Picture);
        //Customer_lRec.CalcFields("Amount Including VAT");


        BodyHTML_lTxt += '<html>';
        BodyHTML_lTxt += '<head>';
        BodyHTML_lTxt += '<meta charset="utf-8">';
        BodyHTML_lTxt += '<title>A simple, clean, and responsive HTML invoice template</title>';

        BodyHTML_lTxt += '<style>';
        BodyHTML_lTxt += '.invoice-box {';
        BodyHTML_lTxt += 'max-width: 800px;';
        BodyHTML_lTxt += 'margin: auto;';
        BodyHTML_lTxt += 'padding: 30px;';
        BodyHTML_lTxt += 'border: 1px solid #eee;';
        BodyHTML_lTxt += 'box-shadow: 0 0 10px rgba(0, 0, 0, .15;';
        BodyHTML_lTxt += 'font-size: 16px;';
        BodyHTML_lTxt += 'line-height: 24px;';
        BodyHTML_lTxt += 'font-family: ''Helvetica Neue'', ''Helvetica'', Helvetica, Arial, sans-serif;';
        BodyHTML_lTxt += 'color: #555;';
        BodyHTML_lTxt += '}';

        BodyHTML_lTxt += '.invoice-box table {';
        BodyHTML_lTxt += 'width: 100%;';
        BodyHTML_lTxt += 'line-height: inherit;';
        BodyHTML_lTxt += 'text-align: left;';
        BodyHTML_lTxt += '}';

        BodyHTML_lTxt += '.invoice-box table td {';
        BodyHTML_lTxt += 'padding: 5px;';
        BodyHTML_lTxt += 'vertical-align: top;';
        BodyHTML_lTxt += '}';

        BodyHTML_lTxt += '.invoice-box table tr td:nth-child(2) {';
        BodyHTML_lTxt += 'text-align: right;';
        BodyHTML_lTxt += '}';

        BodyHTML_lTxt += '.invoice-box table tr.top table td {';
        BodyHTML_lTxt += 'padding-bottom: 20px;';
        BodyHTML_lTxt += '}';

        BodyHTML_lTxt += '.invoice-box table tr.top table td.title {';
        BodyHTML_lTxt += 'font-size: 45px;';
        BodyHTML_lTxt += 'line-height: 45px;';
        BodyHTML_lTxt += 'color: #333;';
        BodyHTML_lTxt += '}';

        BodyHTML_lTxt += '.invoice-box table tr.information table td {';
        BodyHTML_lTxt += 'padding-bottom: 40px;';
        BodyHTML_lTxt += '}';

        BodyHTML_lTxt += '.invoice-box table tr.heading td {';
        BodyHTML_lTxt += 'background: #eee;';
        BodyHTML_lTxt += 'border-bottom: 1px solid #ddd;';
        BodyHTML_lTxt += 'font-weight: bold;';
        BodyHTML_lTxt += '}';

        BodyHTML_lTxt += '.invoice-box table tr.details td {';
        BodyHTML_lTxt += 'padding-bottom: 20px;';
        BodyHTML_lTxt += '}';

        BodyHTML_lTxt += '.invoice-box table tr.item td{';
        BodyHTML_lTxt += 'border-bottom: 1px solid #eee;';
        BodyHTML_lTxt += '}';

        BodyHTML_lTxt += '.invoice-box table tr.item.last td {';
        BodyHTML_lTxt += 'border-bottom: none;';
        BodyHTML_lTxt += '}';

        BodyHTML_lTxt += '.invoice-box table tr.total td:nth-child(2) {';
        BodyHTML_lTxt += 'border-top: 2px solid #eee;';
        BodyHTML_lTxt += 'font-weight: bold;';
        BodyHTML_lTxt += '}';

        BodyHTML_lTxt += '@media only screen and (max-width: 600px) {';
        BodyHTML_lTxt += '.invoice-box table tr.top table td {';
        BodyHTML_lTxt += 'width: 100%;';
        BodyHTML_lTxt += 'display: block;';
        BodyHTML_lTxt += 'text-align: center;';
        BodyHTML_lTxt += '}';

        BodyHTML_lTxt += '.invoice-box table tr.information table td {';
        BodyHTML_lTxt += 'width: 100%;';
        BodyHTML_lTxt += 'display: block;';
        BodyHTML_lTxt += 'text-align: center;';
        BodyHTML_lTxt += '}';
        BodyHTML_lTxt += '}';

        BodyHTML_lTxt += '/** RTL **/';
        BodyHTML_lTxt += '.rtl {';
        BodyHTML_lTxt += 'direction: rtl;';
        BodyHTML_lTxt += 'font-family: Tahoma, ''Helvetica Neue'', ''Helvetica'', Helvetica, Arial, sans-serif;';
        BodyHTML_lTxt += '}';

        BodyHTML_lTxt += '.rtl table {';
        BodyHTML_lTxt += 'text-align: right;';
        BodyHTML_lTxt += '}';

        BodyHTML_lTxt += '.rtl table tr td:nth-child(2) {';
        BodyHTML_lTxt += 'text-align: left;';
        BodyHTML_lTxt += '}';
        BodyHTML_lTxt += '</style>';
        BodyHTML_lTxt += '</head>';

        BodyHTML_lTxt += '<body>';
        BodyHTML_lTxt += '<div class="invoice-box">';
        BodyHTML_lTxt += '<table cellpadding="0" cellspacing="0">';
        BodyHTML_lTxt += '<tr class="top">';
        BodyHTML_lTxt += '<td colspan="2">';
        BodyHTML_lTxt += '<table>';
        BodyHTML_lTxt += '<tr>';
        BodyHTML_lTxt += '<td>';
        BodyHTML_lTxt += '<img src="https://106c4.wpc.azureedge.net/80106C4/Gallery-Prod/cdn/2015-02-24/prod20161101-microsoft-windowsazure-gallery/microsoftdynsmb.3a67602d-0a4f-4ae4-ad03-c1124f6ac3cf.1.0.2/Icon/large.png" height="100" width="100">';
        BodyHTML_lTxt += '</td>';

        BodyHTML_lTxt += '<td class="title">';
        BodyHTML_lTxt += '<b><font size = "5">Customer Statement</font></b><br>';
        BodyHTML_lTxt += '</td>';
        BodyHTML_lTxt += '</tr>';
        BodyHTML_lTxt += '</table>';
        BodyHTML_lTxt += '</td>';
        BodyHTML_lTxt += '</tr>';

        BodyHTML_lTxt += '<tr class="information">';
        BodyHTML_lTxt += '<td colspan="2">';
        BodyHTML_lTxt += '<table>';
        BodyHTML_lTxt += '<tr>';
        BodyHTML_lTxt += '<td>';
        BodyHTML_lTxt += CompanyInfo.Name + '<br>';
        BodyHTML_lTxt += CompanyInfo.Address + '<br>';
        BodyHTML_lTxt += CompanyInfo."Address 2" + '<br>';
        BodyHTML_lTxt += CompanyInfo.City + '<br>';
        BodyHTML_lTxt += CompanyInfo."Post Code" + '<br>';
        BodyHTML_lTxt += CompanyInfo."Phone No." + '<br>';
        BodyHTML_lTxt += '</td>';

        BodyHTML_lTxt += '<td>';
        BodyHTML_lTxt += CompanyInfo."Contact Person" + '<br>';
        BodyHTML_lTxt += CompanyInfo."E-Mail" + '<br>';
        BodyHTML_lTxt += 'Created Date:' + Format(CurrentDateTime()) + '<br>';
        BodyHTML_lTxt += '</td>';
        BodyHTML_lTxt += '</tr>';
        BodyHTML_lTxt += '</table>';
        BodyHTML_lTxt += '</td>';
        BodyHTML_lTxt += '</tr>';

        BodyHTML_lTxt += '<tr class="heading">';
        BodyHTML_lTxt += '<td>';
        BodyHTML_lTxt += 'Account No.';
        BodyHTML_lTxt += '</td>';

        BodyHTML_lTxt += '<td>';
        BodyHTML_lTxt += Customer_lRec."No.";
        BodyHTML_lTxt += '</td>';
        BodyHTML_lTxt += '</tr>';

        BodyHTML_lTxt += '<tr class="details">';
        BodyHTML_lTxt += '<td>';
        BodyHTML_lTxt += 'Name';
        BodyHTML_lTxt += '</td>';

        BodyHTML_lTxt += '<td>';
        BodyHTML_lTxt += Customer_lRec.Name;
        BodyHTML_lTxt += '</td>';
        BodyHTML_lTxt += '</tr>';

        BodyHTML_lTxt += '<tr class="heading">';
        BodyHTML_lTxt += '<td>';
        BodyHTML_lTxt += 'Details:';
        BodyHTML_lTxt += '</td>';

        BodyHTML_lTxt += '<td>';
        BodyHTML_lTxt += '';
        BodyHTML_lTxt += '</td>';
        BodyHTML_lTxt += '</tr>';

        BodyHTML_lTxt += '<tr class="item">';
        BodyHTML_lTxt += '<td>';
        BodyHTML_lTxt += 'Period';
        BodyHTML_lTxt += '</td>';

        BodyHTML_lTxt += '<td>';
        BodyHTML_lTxt += 'From ' + Format(ConvertedStartDate) + ' To ' + Format(ConvertedEndDate);
        BodyHTML_lTxt += '</td>';
        BodyHTML_lTxt += '</tr>';

        BodyHTML_lTxt += '<tr class="item last">';
        BodyHTML_lTxt += '<td>';
        BodyHTML_lTxt += '';
        BodyHTML_lTxt += '</td>';

        BodyHTML_lTxt += '<td>';
        BodyHTML_lTxt += '</td>';
        BodyHTML_lTxt += '</tr>';

        BodyHTML_lTxt += '</table>';
        BodyHTML_lTxt += '</div>';
        BodyHTML_lTxt += '</body>';
        BodyHTML_lTxt += '</html>';
        BodyHTML_lTxt += '<br><br>Kindly go through attached Document for more details.';
        BodyHTML_lTxt += '<br><br>Regards,<br><b>';
        BodyHTML_lTxt += CompanyInfo."Contact Person" + '<br>';
        BodyHTML_lTxt += CompanyInfo.Name + '<br>';
        BodyHTML_lTxt += CompanyInfo.Address + '<br>';
        BodyHTML_lTxt += CompanyInfo."Address 2" + '<br>';
        BodyHTML_lTxt += CompanyInfo.City + ',';
        BodyHTML_lTxt += CompanyInfo."Post Code" + '<br>';
        BodyHTML_lTxt += CompanyInfo."Phone No." + '<br>';
        BodyHTML_lTxt += CompanyInfo."E-Mail" + '<br></b>';

        WebPortalSetup_gRec.Get();
        if WebPortalSetup_gRec."Email as CC for Cust/Vend" then begin
            Clear(Recepients);
            Recepients.Add(Customer_lRec."E-Mail");
            CC.Add(Customer_lRec."E-Mail");
        end;

        EmailMessage.Create(Recepients, 'D365 Business Central', BodyHTML_lTxt, true, CC, BCC);
        XMLParameter := '<?xml version="1.0" standalone="yes"?><ReportParameters name="Customer Ledger" id="70144598"><Options><Field name="ShowAmtInLCY_gBln">false</Field><Field name="SortByName_gBln">false</Field></Options><DataItems><DataItem name="Customer">VERSION(1) SORTING(Field1) WHERE(Field1=1(' + Customer_lRec."No." + '),Field55=1())</DataItem><DataItem name="Detailed Cust. Ledg. Entry">VERSION(1) SORTING(Field9,Field4,Field6)</DataItem><DataItem name="G/L Entry">VERSION(1) SORTING(Field3,Field4)</DataItem></DataItems></ReportParameters>';

        TempBlob.CreateOutStream(EmailoutStream);

        Clear(CustomerLedgerReport);
        CustomerLedgerReport.SetParameter(ConvertedStartDate, ConvertedEndDate);

        CustomerLedgerReport.SaveAs(XMLParameter, ReportFormat::Excel, EmailoutStream);
        TempBlob.CreateInStream(EmailInStream);

        EmailMessage.AddAttachment('CustomerStatement' + CustomerNo_iCod + '.xlsx', 'XLSX', EmailInStream);

        // if SMTPMail.TrySend() then begin
        //     Message('Email Sent Successfully');
        //     exit(true);
        // end;
        Clear(Email);
        if Email.Send(EmailMessage, Enum::"Email Scenario"::Default) then begin
            if GuiAllowed then
                Message('Email Sent Successfully');
            exit(true);
        end
    end;

    procedure PrintCustomerStatementD365_gFnc(CustomerNo_iCod: Code[20]; StateDate_iTxt: Date; EndDate_iTxt: Date; UserID: Code[80]): Boolean
    var
        CompanyInfo: Record "Company Information";
        Customer_lRec: Record Customer;
        CustomerLedgerReport: Report "INT Customer Ledger";
        Email: Codeunit Email;
        EmailMessage: Codeunit "Email Message";
        TempBlob: Codeunit "Temp Blob";
        EmailInStream: InStream;
        BCC: List of [Text];
        CC: List of [Text];
        Recepients: List of [Text];
        EmailoutStream: OutStream;
        BodyHTML_lTxt: Text;
        XMLParameter: Text;
    begin
        if StateDate_iTxt = 0D then
            Error('Please select the Start Date');

        if EndDate_iTxt = 0D then
            Error('Please select the End Date');


        Customer_lRec.Reset();
        Customer_lRec.SetRange("No.", CustomerNo_iCod);
        Customer_lRec.SetFilter("Date Filter", '%1..%2', StateDate_iTxt, EndDate_iTxt);
        if not Customer_lRec.FindFirst() then
            Error('Statement from Date %1 to %2 doesnot exists.', StateDate_iTxt, EndDate_iTxt);

        //XMLParameter := Report.RunRequestPage(70144598);

        Recepients.Add(UserID);
        // SMTPMail.CreateMessage('Intech Systems Pvt. Ltd.', SMTPMailsetup."User ID", Recepients, 'D365 Business Central', '');

        Clear(CompanyInfo);
        CompanyInfo.Get();
        CompanyInfo.CalcFields(Picture);
        //Customer_lRec.CalcFields("Amount Including VAT");


        BodyHTML_lTxt += '<html>';
        BodyHTML_lTxt += '<head>';
        BodyHTML_lTxt += '<meta charset="utf-8">';
        BodyHTML_lTxt += '<title>A simple, clean, and responsive HTML invoice template</title>';

        BodyHTML_lTxt += '<style>';
        BodyHTML_lTxt += '.invoice-box {';
        BodyHTML_lTxt += 'max-width: 800px;';
        BodyHTML_lTxt += 'margin: auto;';
        BodyHTML_lTxt += 'padding: 30px;';
        BodyHTML_lTxt += 'border: 1px solid #eee;';
        BodyHTML_lTxt += 'box-shadow: 0 0 10px rgba(0, 0, 0, .15;';
        BodyHTML_lTxt += 'font-size: 16px;';
        BodyHTML_lTxt += 'line-height: 24px;';
        BodyHTML_lTxt += 'font-family: ''Helvetica Neue'', ''Helvetica'', Helvetica, Arial, sans-serif;';
        BodyHTML_lTxt += 'color: #555;';
        BodyHTML_lTxt += '}';

        BodyHTML_lTxt += '.invoice-box table {';
        BodyHTML_lTxt += 'width: 100%;';
        BodyHTML_lTxt += 'line-height: inherit;';
        BodyHTML_lTxt += 'text-align: left;';
        BodyHTML_lTxt += '}';

        BodyHTML_lTxt += '.invoice-box table td {';
        BodyHTML_lTxt += 'padding: 5px;';
        BodyHTML_lTxt += 'vertical-align: top;';
        BodyHTML_lTxt += '}';

        BodyHTML_lTxt += '.invoice-box table tr td:nth-child(2) {';
        BodyHTML_lTxt += 'text-align: right;';
        BodyHTML_lTxt += '}';

        BodyHTML_lTxt += '.invoice-box table tr.top table td {';
        BodyHTML_lTxt += 'padding-bottom: 20px;';
        BodyHTML_lTxt += '}';

        BodyHTML_lTxt += '.invoice-box table tr.top table td.title {';
        BodyHTML_lTxt += 'font-size: 45px;';
        BodyHTML_lTxt += 'line-height: 45px;';
        BodyHTML_lTxt += 'color: #333;';
        BodyHTML_lTxt += '}';

        BodyHTML_lTxt += '.invoice-box table tr.information table td {';
        BodyHTML_lTxt += 'padding-bottom: 40px;';
        BodyHTML_lTxt += '}';

        BodyHTML_lTxt += '.invoice-box table tr.heading td {';
        BodyHTML_lTxt += 'background: #eee;';
        BodyHTML_lTxt += 'border-bottom: 1px solid #ddd;';
        BodyHTML_lTxt += 'font-weight: bold;';
        BodyHTML_lTxt += '}';

        BodyHTML_lTxt += '.invoice-box table tr.details td {';
        BodyHTML_lTxt += 'padding-bottom: 20px;';
        BodyHTML_lTxt += '}';

        BodyHTML_lTxt += '.invoice-box table tr.item td{';
        BodyHTML_lTxt += 'border-bottom: 1px solid #eee;';
        BodyHTML_lTxt += '}';

        BodyHTML_lTxt += '.invoice-box table tr.item.last td {';
        BodyHTML_lTxt += 'border-bottom: none;';
        BodyHTML_lTxt += '}';

        BodyHTML_lTxt += '.invoice-box table tr.total td:nth-child(2) {';
        BodyHTML_lTxt += 'border-top: 2px solid #eee;';
        BodyHTML_lTxt += 'font-weight: bold;';
        BodyHTML_lTxt += '}';

        BodyHTML_lTxt += '@media only screen and (max-width: 600px) {';
        BodyHTML_lTxt += '.invoice-box table tr.top table td {';
        BodyHTML_lTxt += 'width: 100%;';
        BodyHTML_lTxt += 'display: block;';
        BodyHTML_lTxt += 'text-align: center;';
        BodyHTML_lTxt += '}';

        BodyHTML_lTxt += '.invoice-box table tr.information table td {';
        BodyHTML_lTxt += 'width: 100%;';
        BodyHTML_lTxt += 'display: block;';
        BodyHTML_lTxt += 'text-align: center;';
        BodyHTML_lTxt += '}';
        BodyHTML_lTxt += '}';

        BodyHTML_lTxt += '/** RTL **/';
        BodyHTML_lTxt += '.rtl {';
        BodyHTML_lTxt += 'direction: rtl;';
        BodyHTML_lTxt += 'font-family: Tahoma, ''Helvetica Neue'', ''Helvetica'', Helvetica, Arial, sans-serif;';
        BodyHTML_lTxt += '}';

        BodyHTML_lTxt += '.rtl table {';
        BodyHTML_lTxt += 'text-align: right;';
        BodyHTML_lTxt += '}';

        BodyHTML_lTxt += '.rtl table tr td:nth-child(2) {';
        BodyHTML_lTxt += 'text-align: left;';
        BodyHTML_lTxt += '}';
        BodyHTML_lTxt += '</style>';
        BodyHTML_lTxt += '</head>';

        BodyHTML_lTxt += '<body>';
        BodyHTML_lTxt += '<div class="invoice-box">';
        BodyHTML_lTxt += '<table cellpadding="0" cellspacing="0">';
        BodyHTML_lTxt += '<tr class="top">';
        BodyHTML_lTxt += '<td colspan="2">';
        BodyHTML_lTxt += '<table>';
        BodyHTML_lTxt += '<tr>';
        BodyHTML_lTxt += '<td>';
        BodyHTML_lTxt += '<img src="https://106c4.wpc.azureedge.net/80106C4/Gallery-Prod/cdn/2015-02-24/prod20161101-microsoft-windowsazure-gallery/microsoftdynsmb.3a67602d-0a4f-4ae4-ad03-c1124f6ac3cf.1.0.2/Icon/large.png" height="100" width="100">';
        BodyHTML_lTxt += '</td>';

        BodyHTML_lTxt += '<td class="title">';
        BodyHTML_lTxt += '<b><font size = "5">Customer Statement</font></b><br>';
        BodyHTML_lTxt += '</td>';
        BodyHTML_lTxt += '</tr>';
        BodyHTML_lTxt += '</table>';
        BodyHTML_lTxt += '</td>';
        BodyHTML_lTxt += '</tr>';

        BodyHTML_lTxt += '<tr class="information">';
        BodyHTML_lTxt += '<td colspan="2">';
        BodyHTML_lTxt += '<table>';
        BodyHTML_lTxt += '<tr>';
        BodyHTML_lTxt += '<td>';
        BodyHTML_lTxt += CompanyInfo.Name + '<br>';
        BodyHTML_lTxt += CompanyInfo.Address + '<br>';
        BodyHTML_lTxt += CompanyInfo."Address 2" + '<br>';
        BodyHTML_lTxt += CompanyInfo.City + '<br>';
        BodyHTML_lTxt += CompanyInfo."Post Code" + '<br>';
        BodyHTML_lTxt += CompanyInfo."Phone No." + '<br>';
        BodyHTML_lTxt += '</td>';

        BodyHTML_lTxt += '<td>';
        BodyHTML_lTxt += CompanyInfo."Contact Person" + '<br>';
        BodyHTML_lTxt += CompanyInfo."E-Mail" + '<br>';
        BodyHTML_lTxt += 'Created Date:' + Format(CurrentDateTime()) + '<br>';
        BodyHTML_lTxt += '</td>';
        BodyHTML_lTxt += '</tr>';
        BodyHTML_lTxt += '</table>';
        BodyHTML_lTxt += '</td>';
        BodyHTML_lTxt += '</tr>';

        BodyHTML_lTxt += '<tr class="heading">';
        BodyHTML_lTxt += '<td>';
        BodyHTML_lTxt += 'Account No.';
        BodyHTML_lTxt += '</td>';

        BodyHTML_lTxt += '<td>';
        BodyHTML_lTxt += Customer_lRec."No.";
        BodyHTML_lTxt += '</td>';
        BodyHTML_lTxt += '</tr>';

        BodyHTML_lTxt += '<tr class="details">';
        BodyHTML_lTxt += '<td>';
        BodyHTML_lTxt += 'Name';
        BodyHTML_lTxt += '</td>';

        BodyHTML_lTxt += '<td>';
        BodyHTML_lTxt += Customer_lRec.Name;
        BodyHTML_lTxt += '</td>';
        BodyHTML_lTxt += '</tr>';

        BodyHTML_lTxt += '<tr class="heading">';
        BodyHTML_lTxt += '<td>';
        BodyHTML_lTxt += 'Details:';
        BodyHTML_lTxt += '</td>';

        BodyHTML_lTxt += '<td>';
        BodyHTML_lTxt += '';
        BodyHTML_lTxt += '</td>';
        BodyHTML_lTxt += '</tr>';

        BodyHTML_lTxt += '<tr class="item">';
        BodyHTML_lTxt += '<td>';
        BodyHTML_lTxt += 'Period';
        BodyHTML_lTxt += '</td>';

        BodyHTML_lTxt += '<td>';
        BodyHTML_lTxt += 'From ' + Format(StateDate_iTxt) + ' To ' + Format(EndDate_iTxt);
        BodyHTML_lTxt += '</td>';
        BodyHTML_lTxt += '</tr>';

        BodyHTML_lTxt += '<tr class="item last">';
        BodyHTML_lTxt += '<td>';
        BodyHTML_lTxt += '';
        BodyHTML_lTxt += '</td>';

        BodyHTML_lTxt += '<td>';
        BodyHTML_lTxt += '</td>';
        BodyHTML_lTxt += '</tr>';

        BodyHTML_lTxt += '</table>';
        BodyHTML_lTxt += '</div>';
        BodyHTML_lTxt += '</body>';
        BodyHTML_lTxt += '</html>';
        BodyHTML_lTxt += '<br><br>Kindly go through attached Document for more details.';
        BodyHTML_lTxt += '<br><br>Regards,<br><b>';
        BodyHTML_lTxt += CompanyInfo."Contact Person" + '<br>';
        BodyHTML_lTxt += CompanyInfo.Name + '<br>';
        BodyHTML_lTxt += CompanyInfo.Address + '<br>';
        BodyHTML_lTxt += CompanyInfo."Address 2" + '<br>';
        BodyHTML_lTxt += CompanyInfo.City + ',';
        BodyHTML_lTxt += CompanyInfo."Post Code" + '<br>';
        BodyHTML_lTxt += CompanyInfo."Phone No." + '<br>';
        BodyHTML_lTxt += CompanyInfo."E-Mail" + '<br></b>';

        WebPortalSetup_gRec.Get();
        if WebPortalSetup_gRec."Email as CC for Cust/Vend" then begin
            Clear(Recepients);
            Recepients.Add(Customer_lRec."E-Mail");
            CC.Add(Customer_lRec."E-Mail");
        end;
        EmailMessage.Create(Recepients, 'D365 Business Central', BodyHTML_lTxt, true, CC, BCC);

        XMLParameter := '<?xml version="1.0" standalone="yes"?><ReportParameters name="Customer Ledger" id="70144598"><Options><Field name="ShowAmtInLCY_gBln">false</Field><Field name="SortByName_gBln">false</Field></Options><DataItems><DataItem name="Customer">VERSION(1) SORTING(Field1) WHERE(Field1=1(' + Customer_lRec."No." + '),Field55=1())</DataItem><DataItem name="Detailed Cust. Ledg. Entry">VERSION(1) SORTING(Field9,Field4,Field6)</DataItem><DataItem name="G/L Entry">VERSION(1) SORTING(Field3,Field4)</DataItem></DataItems></ReportParameters>';

        TempBlob.CreateOutStream(EmailoutStream);
        Clear(CustomerLedgerReport);
        CustomerLedgerReport.SetParameter(StateDate_iTxt, EndDate_iTxt);
        CustomerLedgerReport.SaveAs(XMLParameter, ReportFormat::Pdf, EmailoutStream);
        TempBlob.CreateInStream(EmailInStream);
        EmailMessage.AddAttachment('CustomerStatement' + CustomerNo_iCod + '.pdf', 'PDF', EmailInStream);
        // if SMTPMail.TrySend() then begin
        //     Message('Email Sent Successfully');
        //     exit(true);
        // end;
        Clear(Email);
        if Email.Send(EmailMessage, Enum::"Email Scenario"::Default) then begin
            if GuiAllowed then
                Message('Email Sent Successfully');
            exit(true);
        end;
    end;

    procedure PrintCustomerStatementEXCELD365_gFnc(CustomerNo_iCod: Code[20]; StateDate_iTxt: Date; EndDate_iTxt: Date; UserID: Code[80]): Boolean
    var
        CompanyInfo: Record "Company Information";
        Customer_lRec: Record Customer;
        CustomerLedgerReport: Report "INT Customer Ledger";
        Email: Codeunit Email;
        EmailMessage: Codeunit "Email Message";
        TempBlob: Codeunit "Temp Blob";
        EmailInStream: InStream;
        BCC: List of [Text];
        CC: List of [Text];
        Recepients: List of [Text];
        EmailoutStream: OutStream;
        BodyHTML_lTxt: Text;
        XMLParameter: Text;
    begin
        if StateDate_iTxt = 0D then
            Error('Please select the Start Date');

        if EndDate_iTxt = 0D then
            Error('Please select the End Date');


        Customer_lRec.Reset();
        Customer_lRec.SetRange("No.", CustomerNo_iCod);
        Customer_lRec.SetFilter("Date Filter", '%1..%2', StateDate_iTxt, EndDate_iTxt);
        if not Customer_lRec.FindFirst() then
            Error('Statement from Date %1 to %2 doesnot exists.', StateDate_iTxt, EndDate_iTxt);

        //XMLParameter := Report.RunRequestPage(70144598);

        Recepients.Add(UserID);
        //SMTPMail.CreateMessage('Intech Systems Pvt. Ltd.', SMTPMailsetup."User ID", Recepients, 'D365 Business Central', '');

        Clear(CompanyInfo);
        CompanyInfo.Get();
        CompanyInfo.CalcFields(Picture);
        //Customer_lRec.CalcFields("Amount Including VAT");


        BodyHTML_lTxt += '<html>';
        BodyHTML_lTxt += '<head>';
        BodyHTML_lTxt += '<meta charset="utf-8">';
        BodyHTML_lTxt += '<title>A simple, clean, and responsive HTML invoice template</title>';

        BodyHTML_lTxt += '<style>';
        BodyHTML_lTxt += '.invoice-box {';
        BodyHTML_lTxt += 'max-width: 800px;';
        BodyHTML_lTxt += 'margin: auto;';
        BodyHTML_lTxt += 'padding: 30px;';
        BodyHTML_lTxt += 'border: 1px solid #eee;';
        BodyHTML_lTxt += 'box-shadow: 0 0 10px rgba(0, 0, 0, .15;';
        BodyHTML_lTxt += 'font-size: 16px;';
        BodyHTML_lTxt += 'line-height: 24px;';
        BodyHTML_lTxt += 'font-family: ''Helvetica Neue'', ''Helvetica'', Helvetica, Arial, sans-serif;';
        BodyHTML_lTxt += 'color: #555;';
        BodyHTML_lTxt += '}';

        BodyHTML_lTxt += '.invoice-box table {';
        BodyHTML_lTxt += 'width: 100%;';
        BodyHTML_lTxt += 'line-height: inherit;';
        BodyHTML_lTxt += 'text-align: left;';
        BodyHTML_lTxt += '}';

        BodyHTML_lTxt += '.invoice-box table td {';
        BodyHTML_lTxt += 'padding: 5px;';
        BodyHTML_lTxt += 'vertical-align: top;';
        BodyHTML_lTxt += '}';

        BodyHTML_lTxt += '.invoice-box table tr td:nth-child(2) {';
        BodyHTML_lTxt += 'text-align: right;';
        BodyHTML_lTxt += '}';

        BodyHTML_lTxt += '.invoice-box table tr.top table td {';
        BodyHTML_lTxt += 'padding-bottom: 20px;';
        BodyHTML_lTxt += '}';

        BodyHTML_lTxt += '.invoice-box table tr.top table td.title {';
        BodyHTML_lTxt += 'font-size: 45px;';
        BodyHTML_lTxt += 'line-height: 45px;';
        BodyHTML_lTxt += 'color: #333;';
        BodyHTML_lTxt += '}';

        BodyHTML_lTxt += '.invoice-box table tr.information table td {';
        BodyHTML_lTxt += 'padding-bottom: 40px;';
        BodyHTML_lTxt += '}';

        BodyHTML_lTxt += '.invoice-box table tr.heading td {';
        BodyHTML_lTxt += 'background: #eee;';
        BodyHTML_lTxt += 'border-bottom: 1px solid #ddd;';
        BodyHTML_lTxt += 'font-weight: bold;';
        BodyHTML_lTxt += '}';

        BodyHTML_lTxt += '.invoice-box table tr.details td {';
        BodyHTML_lTxt += 'padding-bottom: 20px;';
        BodyHTML_lTxt += '}';

        BodyHTML_lTxt += '.invoice-box table tr.item td{';
        BodyHTML_lTxt += 'border-bottom: 1px solid #eee;';
        BodyHTML_lTxt += '}';

        BodyHTML_lTxt += '.invoice-box table tr.item.last td {';
        BodyHTML_lTxt += 'border-bottom: none;';
        BodyHTML_lTxt += '}';

        BodyHTML_lTxt += '.invoice-box table tr.total td:nth-child(2) {';
        BodyHTML_lTxt += 'border-top: 2px solid #eee;';
        BodyHTML_lTxt += 'font-weight: bold;';
        BodyHTML_lTxt += '}';

        BodyHTML_lTxt += '@media only screen and (max-width: 600px) {';
        BodyHTML_lTxt += '.invoice-box table tr.top table td {';
        BodyHTML_lTxt += 'width: 100%;';
        BodyHTML_lTxt += 'display: block;';
        BodyHTML_lTxt += 'text-align: center;';
        BodyHTML_lTxt += '}';

        BodyHTML_lTxt += '.invoice-box table tr.information table td {';
        BodyHTML_lTxt += 'width: 100%;';
        BodyHTML_lTxt += 'display: block;';
        BodyHTML_lTxt += 'text-align: center;';
        BodyHTML_lTxt += '}';
        BodyHTML_lTxt += '}';

        BodyHTML_lTxt += '/** RTL **/';
        BodyHTML_lTxt += '.rtl {';
        BodyHTML_lTxt += 'direction: rtl;';
        BodyHTML_lTxt += 'font-family: Tahoma, ''Helvetica Neue'', ''Helvetica'', Helvetica, Arial, sans-serif;';
        BodyHTML_lTxt += '}';

        BodyHTML_lTxt += '.rtl table {';
        BodyHTML_lTxt += 'text-align: right;';
        BodyHTML_lTxt += '}';

        BodyHTML_lTxt += '.rtl table tr td:nth-child(2) {';
        BodyHTML_lTxt += 'text-align: left;';
        BodyHTML_lTxt += '}';
        BodyHTML_lTxt += '</style>';
        BodyHTML_lTxt += '</head>';

        BodyHTML_lTxt += '<body>';
        BodyHTML_lTxt += '<div class="invoice-box">';
        BodyHTML_lTxt += '<table cellpadding="0" cellspacing="0">';
        BodyHTML_lTxt += '<tr class="top">';
        BodyHTML_lTxt += '<td colspan="2">';
        BodyHTML_lTxt += '<table>';
        BodyHTML_lTxt += '<tr>';
        BodyHTML_lTxt += '<td>';
        BodyHTML_lTxt += '<img src="https://106c4.wpc.azureedge.net/80106C4/Gallery-Prod/cdn/2015-02-24/prod20161101-microsoft-windowsazure-gallery/microsoftdynsmb.3a67602d-0a4f-4ae4-ad03-c1124f6ac3cf.1.0.2/Icon/large.png" height="100" width="100">';
        BodyHTML_lTxt += '</td>';

        BodyHTML_lTxt += '<td class="title">';
        BodyHTML_lTxt += '<b><font size = "5">Customer Statement</font></b><br>';
        BodyHTML_lTxt += '</td>';
        BodyHTML_lTxt += '</tr>';
        BodyHTML_lTxt += '</table>';
        BodyHTML_lTxt += '</td>';
        BodyHTML_lTxt += '</tr>';

        BodyHTML_lTxt += '<tr class="information">';
        BodyHTML_lTxt += '<td colspan="2">';
        BodyHTML_lTxt += '<table>';
        BodyHTML_lTxt += '<tr>';
        BodyHTML_lTxt += '<td>';
        BodyHTML_lTxt += CompanyInfo.Name + '<br>';
        BodyHTML_lTxt += CompanyInfo.Address + '<br>';
        BodyHTML_lTxt += CompanyInfo."Address 2" + '<br>';
        BodyHTML_lTxt += CompanyInfo.City + '<br>';
        BodyHTML_lTxt += CompanyInfo."Post Code" + '<br>';
        BodyHTML_lTxt += CompanyInfo."Phone No." + '<br>';
        BodyHTML_lTxt += '</td>';

        BodyHTML_lTxt += '<td>';
        BodyHTML_lTxt += CompanyInfo."Contact Person" + '<br>';
        BodyHTML_lTxt += CompanyInfo."E-Mail" + '<br>';
        BodyHTML_lTxt += 'Created Date:' + Format(CurrentDateTime()) + '<br>';
        BodyHTML_lTxt += '</td>';
        BodyHTML_lTxt += '</tr>';
        BodyHTML_lTxt += '</table>';
        BodyHTML_lTxt += '</td>';
        BodyHTML_lTxt += '</tr>';

        BodyHTML_lTxt += '<tr class="heading">';
        BodyHTML_lTxt += '<td>';
        BodyHTML_lTxt += 'Account No.';
        BodyHTML_lTxt += '</td>';

        BodyHTML_lTxt += '<td>';
        BodyHTML_lTxt += Customer_lRec."No.";
        BodyHTML_lTxt += '</td>';
        BodyHTML_lTxt += '</tr>';

        BodyHTML_lTxt += '<tr class="details">';
        BodyHTML_lTxt += '<td>';
        BodyHTML_lTxt += 'Name';
        BodyHTML_lTxt += '</td>';

        BodyHTML_lTxt += '<td>';
        BodyHTML_lTxt += Customer_lRec.Name;
        BodyHTML_lTxt += '</td>';
        BodyHTML_lTxt += '</tr>';

        BodyHTML_lTxt += '<tr class="heading">';
        BodyHTML_lTxt += '<td>';
        BodyHTML_lTxt += 'Details:';
        BodyHTML_lTxt += '</td>';

        BodyHTML_lTxt += '<td>';
        BodyHTML_lTxt += '';
        BodyHTML_lTxt += '</td>';
        BodyHTML_lTxt += '</tr>';

        BodyHTML_lTxt += '<tr class="item">';
        BodyHTML_lTxt += '<td>';
        BodyHTML_lTxt += 'Period';
        BodyHTML_lTxt += '</td>';

        BodyHTML_lTxt += '<td>';
        BodyHTML_lTxt += 'From ' + Format(StateDate_iTxt) + ' To ' + Format(EndDate_iTxt);
        BodyHTML_lTxt += '</td>';
        BodyHTML_lTxt += '</tr>';

        BodyHTML_lTxt += '<tr class="item last">';
        BodyHTML_lTxt += '<td>';
        BodyHTML_lTxt += '';
        BodyHTML_lTxt += '</td>';

        BodyHTML_lTxt += '<td>';
        BodyHTML_lTxt += '</td>';
        BodyHTML_lTxt += '</tr>';

        BodyHTML_lTxt += '</table>';
        BodyHTML_lTxt += '</div>';
        BodyHTML_lTxt += '</body>';
        BodyHTML_lTxt += '</html>';
        BodyHTML_lTxt += '<br><br>Kindly go through attached Document for more details.';
        BodyHTML_lTxt += '<br><br>Regards,<br><b>';
        BodyHTML_lTxt += CompanyInfo."Contact Person" + '<br>';
        BodyHTML_lTxt += CompanyInfo.Name + '<br>';
        BodyHTML_lTxt += CompanyInfo.Address + '<br>';
        BodyHTML_lTxt += CompanyInfo."Address 2" + '<br>';
        BodyHTML_lTxt += CompanyInfo.City + ',';
        BodyHTML_lTxt += CompanyInfo."Post Code" + '<br>';
        BodyHTML_lTxt += CompanyInfo."Phone No." + '<br>';
        BodyHTML_lTxt += CompanyInfo."E-Mail" + '<br></b>';

        WebPortalSetup_gRec.Get();
        if WebPortalSetup_gRec."Email as CC for Cust/Vend" then begin
            Clear(Recepients);
            Recepients.Add(Customer_lRec."E-Mail");
            CC.Add(Customer_lRec."E-Mail");
        end;
        EmailMessage.Create(Recepients, 'D365 Business Central', BodyHTML_lTxt, true, CC, BCC);

        XMLParameter := '<?xml version="1.0" standalone="yes"?><ReportParameters name="Customer Ledger" id="70144598"><Options><Field name="ShowAmtInLCY_gBln">false</Field><Field name="SortByName_gBln">false</Field></Options><DataItems><DataItem name="Customer">VERSION(1) SORTING(Field1) WHERE(Field1=1(' + Customer_lRec."No." + '),Field55=1())</DataItem><DataItem name="Detailed Cust. Ledg. Entry">VERSION(1) SORTING(Field9,Field4,Field6)</DataItem><DataItem name="G/L Entry">VERSION(1) SORTING(Field3,Field4)</DataItem></DataItems></ReportParameters>';
        TempBlob.CreateOutStream(EmailoutStream);
        Clear(CustomerLedgerReport);
        CustomerLedgerReport.SetParameter(StateDate_iTxt, EndDate_iTxt);
        CustomerLedgerReport.SaveAs(XMLParameter, ReportFormat::Excel, EmailoutStream);
        TempBlob.CreateInStream(EmailInStream);
        EmailMessage.AddAttachment('CustomerStatement' + CustomerNo_iCod + '.xlsx', 'XLSX', EmailInStream);

        // if SMTPMail.TrySend() then begin
        //     Message('Email Sent Successfully');
        //     exit(true);
        // end;
        Clear(Email);
        if Email.Send(EmailMessage, Enum::"Email Scenario"::Default) then begin
            if GuiAllowed then
                Message('Email Sent Successfully');
            exit(true);
        end;
    end;

    procedure PrintVendorStatement_gFnc(VendorNo_iCod: Code[20]; StateDate_iTxt: Text[20]; EndDate_iTxt: Text[20]; UserID: Code[80]): Boolean
    var
        CompanyInfo: Record "Company Information";
        Vendor_lRec: Record Vendor;
        VendorLedgerReport: Report "INT Vendor Ledger";
        Email: Codeunit Email;
        EmailMessage: Codeunit "Email Message";
        TempBlob: Codeunit "Temp Blob";
        ConvertedEndDate: Date;
        ConvertedStartDate: Date;
        EmailInStream: InStream;
        DD: Integer;
        MM: Integer;
        YYYY: Integer;
        BCC: List of [Text];
        CC: List of [Text];
        Recepients: List of [Text];
        EmailoutStream: OutStream;
        BodyHTML_lTxt: Text;
        XMLParameter: Text;
    begin
        if StateDate_iTxt = '' then
            Error('Please select the Start Date');

        if EndDate_iTxt = '' then
            Error('Please select the End Date');

        ConvertedStartDate := 0D;
        MM := 0;
        DD := 0;
        YYYY := 0;
        Evaluate(MM, CopyStr(StateDate_iTxt, 1, 2));
        Evaluate(DD, CopyStr(StateDate_iTxt, 4, 2));
        Evaluate(YYYY, CopyStr(StateDate_iTxt, 7, 4));

        ConvertedStartDate := DMY2Date(DD, MM, YYYY);

        ConvertedEndDate := 0D;
        MM := 0;
        DD := 0;
        YYYY := 0;
        Evaluate(MM, CopyStr(EndDate_iTxt, 1, 2));
        Evaluate(DD, CopyStr(EndDate_iTxt, 4, 2));
        Evaluate(YYYY, CopyStr(EndDate_iTxt, 7, 4));

        ConvertedEndDate := DMY2Date(DD, MM, YYYY);

        Vendor_lRec.Reset();
        Vendor_lRec.SetRange("No.", VendorNo_iCod);
        Vendor_lRec.SetFilter("Date Filter", '%1..%2', ConvertedStartDate, ConvertedEndDate);
        if not Vendor_lRec.FindFirst() then
            Error('Statement from Date %1 to %2 doesnot exists.', ConvertedStartDate, ConvertedEndDate);

        //XMLParameter := Report.RunRequestPage(70144602);
        Clear(CompanyInfo);
        CompanyInfo.Get();

        Recepients.Add(UserID);
        //SMTPMail.CreateMessage('Intech Systems Pvt. Ltd.', SMTPMailsetup."User ID", Recepients, 'D365 Business Central', '');

        BodyHTML_lTxt += '<html>';
        BodyHTML_lTxt += '<head>';
        BodyHTML_lTxt += '<meta charset="utf-8">';
        BodyHTML_lTxt += '<title>A simple, clean, and responsive HTML invoice template</title>';

        BodyHTML_lTxt += '<style>';
        BodyHTML_lTxt += '.invoice-box {';
        BodyHTML_lTxt += 'max-width: 800px;';
        BodyHTML_lTxt += 'margin: auto;';
        BodyHTML_lTxt += 'padding: 30px;';
        BodyHTML_lTxt += 'border: 1px solid #eee;';
        BodyHTML_lTxt += 'box-shadow: 0 0 10px rgba(0, 0, 0, .15;';
        BodyHTML_lTxt += 'font-size: 16px;';
        BodyHTML_lTxt += 'line-height: 24px;';
        BodyHTML_lTxt += 'font-family: ''Helvetica Neue'', ''Helvetica'', Helvetica, Arial, sans-serif;';
        BodyHTML_lTxt += 'color: #555;';
        BodyHTML_lTxt += '}';

        BodyHTML_lTxt += '.invoice-box table {';
        BodyHTML_lTxt += 'width: 100%;';
        BodyHTML_lTxt += 'line-height: inherit;';
        BodyHTML_lTxt += 'text-align: left;';
        BodyHTML_lTxt += '}';

        BodyHTML_lTxt += '.invoice-box table td {';
        BodyHTML_lTxt += 'padding: 5px;';
        BodyHTML_lTxt += 'vertical-align: top;';
        BodyHTML_lTxt += '}';

        BodyHTML_lTxt += '.invoice-box table tr td:nth-child(2) {';
        BodyHTML_lTxt += 'text-align: right;';
        BodyHTML_lTxt += '}';

        BodyHTML_lTxt += '.invoice-box table tr.top table td {';
        BodyHTML_lTxt += 'padding-bottom: 20px;';
        BodyHTML_lTxt += '}';

        BodyHTML_lTxt += '.invoice-box table tr.top table td.title {';
        BodyHTML_lTxt += 'font-size: 45px;';
        BodyHTML_lTxt += 'line-height: 45px;';
        BodyHTML_lTxt += 'color: #333;';
        BodyHTML_lTxt += '}';

        BodyHTML_lTxt += '.invoice-box table tr.information table td {';
        BodyHTML_lTxt += 'padding-bottom: 40px;';
        BodyHTML_lTxt += '}';

        BodyHTML_lTxt += '.invoice-box table tr.heading td {';
        BodyHTML_lTxt += 'background: #eee;';
        BodyHTML_lTxt += 'border-bottom: 1px solid #ddd;';
        BodyHTML_lTxt += 'font-weight: bold;';
        BodyHTML_lTxt += '}';

        BodyHTML_lTxt += '.invoice-box table tr.details td {';
        BodyHTML_lTxt += 'padding-bottom: 20px;';
        BodyHTML_lTxt += '}';

        BodyHTML_lTxt += '.invoice-box table tr.item td{';
        BodyHTML_lTxt += 'border-bottom: 1px solid #eee;';
        BodyHTML_lTxt += '}';

        BodyHTML_lTxt += '.invoice-box table tr.item.last td {';
        BodyHTML_lTxt += 'border-bottom: none;';
        BodyHTML_lTxt += '}';

        BodyHTML_lTxt += '.invoice-box table tr.total td:nth-child(2) {';
        BodyHTML_lTxt += 'border-top: 2px solid #eee;';
        BodyHTML_lTxt += 'font-weight: bold;';
        BodyHTML_lTxt += '}';

        BodyHTML_lTxt += '@media only screen and (max-width: 600px) {';
        BodyHTML_lTxt += '.invoice-box table tr.top table td {';
        BodyHTML_lTxt += 'width: 100%;';
        BodyHTML_lTxt += 'display: block;';
        BodyHTML_lTxt += 'text-align: center;';
        BodyHTML_lTxt += '}';

        BodyHTML_lTxt += '.invoice-box table tr.information table td {';
        BodyHTML_lTxt += 'width: 100%;';
        BodyHTML_lTxt += 'display: block;';
        BodyHTML_lTxt += 'text-align: center;';
        BodyHTML_lTxt += '}';
        BodyHTML_lTxt += '}';

        BodyHTML_lTxt += '/** RTL **/';
        BodyHTML_lTxt += '.rtl {';
        BodyHTML_lTxt += 'direction: rtl;';
        BodyHTML_lTxt += 'font-family: Tahoma, ''Helvetica Neue'', ''Helvetica'', Helvetica, Arial, sans-serif;';
        BodyHTML_lTxt += '}';

        BodyHTML_lTxt += '.rtl table {';
        BodyHTML_lTxt += 'text-align: right;';
        BodyHTML_lTxt += '}';

        BodyHTML_lTxt += '.rtl table tr td:nth-child(2) {';
        BodyHTML_lTxt += 'text-align: left;';
        BodyHTML_lTxt += '}';
        BodyHTML_lTxt += '</style>';
        BodyHTML_lTxt += '</head>';

        BodyHTML_lTxt += '<body>';
        BodyHTML_lTxt += '<div class="invoice-box">';
        BodyHTML_lTxt += '<table cellpadding="0" cellspacing="0">';
        BodyHTML_lTxt += '<tr class="top">';
        BodyHTML_lTxt += '<td colspan="2">';
        BodyHTML_lTxt += '<table>';
        BodyHTML_lTxt += '<tr>';
        BodyHTML_lTxt += '<td>';
        BodyHTML_lTxt += '<img src="https://106c4.wpc.azureedge.net/80106C4/Gallery-Prod/cdn/2015-02-24/prod20161101-microsoft-windowsazure-gallery/microsoftdynsmb.3a67602d-0a4f-4ae4-ad03-c1124f6ac3cf.1.0.2/Icon/large.png" height="100" width="100">';
        BodyHTML_lTxt += '</td>';

        BodyHTML_lTxt += '<td class="title">';
        BodyHTML_lTxt += '<b><font size = "5">Vendor Statement</font></b><br>';
        BodyHTML_lTxt += '</td>';
        BodyHTML_lTxt += '</tr>';
        BodyHTML_lTxt += '</table>';
        BodyHTML_lTxt += '</td>';
        BodyHTML_lTxt += '</tr>';

        BodyHTML_lTxt += '<tr class="information">';
        BodyHTML_lTxt += '<td colspan="2">';
        BodyHTML_lTxt += '<table>';
        BodyHTML_lTxt += '<tr>';
        BodyHTML_lTxt += '<td>';
        BodyHTML_lTxt += CompanyInfo.Name + '<br>';
        BodyHTML_lTxt += CompanyInfo.Address + '<br>';
        BodyHTML_lTxt += CompanyInfo."Address 2" + '<br>';
        BodyHTML_lTxt += CompanyInfo.City + '<br>';
        BodyHTML_lTxt += CompanyInfo."Post Code" + '<br>';
        BodyHTML_lTxt += CompanyInfo."Phone No." + '<br>';
        BodyHTML_lTxt += '</td>';

        BodyHTML_lTxt += '<td>';
        BodyHTML_lTxt += CompanyInfo."Contact Person" + '<br>';
        BodyHTML_lTxt += CompanyInfo."E-Mail" + '<br>';
        BodyHTML_lTxt += 'Created Date:' + Format(CurrentDateTime()) + '<br>';
        BodyHTML_lTxt += '</td>';
        BodyHTML_lTxt += '</tr>';
        BodyHTML_lTxt += '</table>';
        BodyHTML_lTxt += '</td>';
        BodyHTML_lTxt += '</tr>';

        BodyHTML_lTxt += '<tr class="heading">';
        BodyHTML_lTxt += '<td>';
        BodyHTML_lTxt += 'Account No.';
        BodyHTML_lTxt += '</td>';

        BodyHTML_lTxt += '<td>';
        BodyHTML_lTxt += Vendor_lRec."No.";
        BodyHTML_lTxt += '</td>';
        BodyHTML_lTxt += '</tr>';

        BodyHTML_lTxt += '<tr class="details">';
        BodyHTML_lTxt += '<td>';
        BodyHTML_lTxt += 'Name';
        BodyHTML_lTxt += '</td>';

        BodyHTML_lTxt += '<td>';
        BodyHTML_lTxt += Vendor_lRec.Name;
        BodyHTML_lTxt += '</td>';
        BodyHTML_lTxt += '</tr>';

        BodyHTML_lTxt += '<tr class="heading">';
        BodyHTML_lTxt += '<td>';
        BodyHTML_lTxt += 'Details:';
        BodyHTML_lTxt += '</td>';

        BodyHTML_lTxt += '<td>';
        BodyHTML_lTxt += '';
        BodyHTML_lTxt += '</td>';
        BodyHTML_lTxt += '</tr>';

        BodyHTML_lTxt += '<tr class="item">';
        BodyHTML_lTxt += '<td>';
        BodyHTML_lTxt += 'Period';
        BodyHTML_lTxt += '</td>';

        BodyHTML_lTxt += '<td>';
        BodyHTML_lTxt += 'From ' + Format(ConvertedStartDate) + ' To ' + Format(ConvertedEndDate);
        BodyHTML_lTxt += '</td>';
        BodyHTML_lTxt += '</tr>';

        BodyHTML_lTxt += '<tr class="item last">';
        BodyHTML_lTxt += '<td>';
        BodyHTML_lTxt += '';
        BodyHTML_lTxt += '</td>';

        BodyHTML_lTxt += '<td>';
        BodyHTML_lTxt += '</td>';
        BodyHTML_lTxt += '</tr>';

        BodyHTML_lTxt += '</table>';
        BodyHTML_lTxt += '</div>';
        BodyHTML_lTxt += '</body>';
        BodyHTML_lTxt += '</html>';
        BodyHTML_lTxt += '<br><br>Kindly go through attached Document for more details.';
        BodyHTML_lTxt += '<br><br>Regards,<br><b>';
        BodyHTML_lTxt += CompanyInfo."Contact Person" + '<br>';
        BodyHTML_lTxt += CompanyInfo.Name + '<br>';
        BodyHTML_lTxt += CompanyInfo.Address + '<br>';
        BodyHTML_lTxt += CompanyInfo."Address 2" + '<br>';
        BodyHTML_lTxt += CompanyInfo.City + ',';
        BodyHTML_lTxt += CompanyInfo."Post Code" + '<br>';
        BodyHTML_lTxt += CompanyInfo."Phone No." + '<br>';
        BodyHTML_lTxt += CompanyInfo."E-Mail" + '<br></b>';

        WebPortalSetup_gRec.Get();
        if WebPortalSetup_gRec."Email as CC for Cust/Vend" then begin
            Clear(Recepients);
            Recepients.Add(Vendor_lRec."E-Mail");
            CC.Add(Vendor_lRec."E-Mail");
        end;

        EmailMessage.Create(Recepients, 'D365 Business Central', BodyHTML_lTxt, true, CC, BCC);

        XMLParameter := '<?xml version="1.0" standalone="yes"?><ReportParameters name="Vendor Ledger" id="70144602"><Options><Field name="PrintDetail_gBln">false</Field><Field name="PrintLineNarration_gBln">false</Field><Field name="PrintVchNarration_gBln">false</Field><Field name="ShowAmtInLCY_gBln">false</Field><Field name="SortByName_gBln">false</Field></Options><DataItems><DataItem name="Vendor">VERSION(1) SORTING(Field1) WHERE(Field1=1(' + Vendor_lRec."No." + '),Field55=1(2012-01-01..2018-01-01))</DataItem><DataItem name="Detailed Vendor Ledg. Entry">VERSION(1) SORTING(Field9,Field4,Field6)</DataItem><DataItem name="G/L Entry">VERSION(1) SORTING(Field3,Field4)</DataItem></DataItems></ReportParameters>';

        TempBlob.CreateOutStream(EmailoutStream);
        Clear(VendorLedgerReport);
        VendorLedgerReport.SetParameter(ConvertedStartDate, ConvertedEndDate);
        VendorLedgerReport.SaveAs(XMLParameter, ReportFormat::Pdf, EmailoutStream);
        TempBlob.CreateInStream(EmailInStream);
        EmailMessage.AddAttachment('VendorStatement' + VendorNo_iCod + '.pdf', 'PDF', EmailInStream);

        // if SMTPMail.TrySend() then begin
        //     Message('Email Sent Successfully');
        //     exit(true);
        // end;
        Clear(Email);
        if Email.Send(EmailMessage, Enum::"Email Scenario"::Default) then begin
            if GuiAllowed then
                Message('Email Sent Successfully');
            exit(true);
        end;
    end;

    procedure PrintVendorStatementEXCEL_gFnc(VendorNo_iCod: Code[20]; StateDate_iTxt: Text[20]; EndDate_iTxt: Text[20]; UserID: Code[80]): Boolean
    var
        CompanyInfo: Record "Company Information";
        Vendor_lRec: Record Vendor;
        VendorLedgerReport: Report "INT Vendor Ledger";
        Email: Codeunit Email;
        EmailMessage: Codeunit "Email Message";
        TempBlob: Codeunit "Temp Blob";
        ConvertedEndDate: Date;
        ConvertedStartDate: Date;
        EmailInStream: InStream;
        DD: Integer;
        MM: Integer;
        YYYY: Integer;
        BCC: List of [Text];
        CC: List of [Text];
        Recepients: List of [Text];
        EmailoutStream: OutStream;
        BodyHTML_lTxt: Text;
        XMLParameter: Text;
    begin
        if StateDate_iTxt = '' then
            Error('Please select the Start Date');

        if EndDate_iTxt = '' then
            Error('Please select the End Date');

        ConvertedStartDate := 0D;
        MM := 0;
        DD := 0;
        YYYY := 0;
        Evaluate(MM, CopyStr(StateDate_iTxt, 1, 2));
        Evaluate(DD, CopyStr(StateDate_iTxt, 4, 2));
        Evaluate(YYYY, CopyStr(StateDate_iTxt, 7, 4));

        ConvertedStartDate := DMY2Date(DD, MM, YYYY);

        ConvertedEndDate := 0D;
        MM := 0;
        DD := 0;
        YYYY := 0;
        Evaluate(MM, CopyStr(EndDate_iTxt, 1, 2));
        Evaluate(DD, CopyStr(EndDate_iTxt, 4, 2));
        Evaluate(YYYY, CopyStr(EndDate_iTxt, 7, 4));

        ConvertedEndDate := DMY2Date(DD, MM, YYYY);

        Vendor_lRec.Reset();
        Vendor_lRec.SetRange("No.", VendorNo_iCod);
        Vendor_lRec.SetFilter("Date Filter", '%1..%2', ConvertedStartDate, ConvertedEndDate);
        if not Vendor_lRec.FindFirst() then
            Error('Statement from Date %1 to %2 doesnot exists.', ConvertedStartDate, ConvertedEndDate);

        //XMLParameter := Report.RunRequestPage(70144602);

        Clear(CompanyInfo);
        CompanyInfo.Get();

        Recepients.Add(UserID);
        // SMTPMail.CreateMessage('Intech Systems Pvt. Ltd.', SMTPMailsetup."User ID", Recepients, 'D365 Business Central', '');

        BodyHTML_lTxt += '<html>';
        BodyHTML_lTxt += '<head>';
        BodyHTML_lTxt += '<meta charset="utf-8">';
        BodyHTML_lTxt += '<title>A simple, clean, and responsive HTML invoice template</title>';

        BodyHTML_lTxt += '<style>';
        BodyHTML_lTxt += '.invoice-box {';
        BodyHTML_lTxt += 'max-width: 800px;';
        BodyHTML_lTxt += 'margin: auto;';
        BodyHTML_lTxt += 'padding: 30px;';
        BodyHTML_lTxt += 'border: 1px solid #eee;';
        BodyHTML_lTxt += 'box-shadow: 0 0 10px rgba(0, 0, 0, .15;';
        BodyHTML_lTxt += 'font-size: 16px;';
        BodyHTML_lTxt += 'line-height: 24px;';
        BodyHTML_lTxt += 'font-family: ''Helvetica Neue'', ''Helvetica'', Helvetica, Arial, sans-serif;';
        BodyHTML_lTxt += 'color: #555;';
        BodyHTML_lTxt += '}';

        BodyHTML_lTxt += '.invoice-box table {';
        BodyHTML_lTxt += 'width: 100%;';
        BodyHTML_lTxt += 'line-height: inherit;';
        BodyHTML_lTxt += 'text-align: left;';
        BodyHTML_lTxt += '}';

        BodyHTML_lTxt += '.invoice-box table td {';
        BodyHTML_lTxt += 'padding: 5px;';
        BodyHTML_lTxt += 'vertical-align: top;';
        BodyHTML_lTxt += '}';

        BodyHTML_lTxt += '.invoice-box table tr td:nth-child(2) {';
        BodyHTML_lTxt += 'text-align: right;';
        BodyHTML_lTxt += '}';

        BodyHTML_lTxt += '.invoice-box table tr.top table td {';
        BodyHTML_lTxt += 'padding-bottom: 20px;';
        BodyHTML_lTxt += '}';

        BodyHTML_lTxt += '.invoice-box table tr.top table td.title {';
        BodyHTML_lTxt += 'font-size: 45px;';
        BodyHTML_lTxt += 'line-height: 45px;';
        BodyHTML_lTxt += 'color: #333;';
        BodyHTML_lTxt += '}';

        BodyHTML_lTxt += '.invoice-box table tr.information table td {';
        BodyHTML_lTxt += 'padding-bottom: 40px;';
        BodyHTML_lTxt += '}';

        BodyHTML_lTxt += '.invoice-box table tr.heading td {';
        BodyHTML_lTxt += 'background: #eee;';
        BodyHTML_lTxt += 'border-bottom: 1px solid #ddd;';
        BodyHTML_lTxt += 'font-weight: bold;';
        BodyHTML_lTxt += '}';

        BodyHTML_lTxt += '.invoice-box table tr.details td {';
        BodyHTML_lTxt += 'padding-bottom: 20px;';
        BodyHTML_lTxt += '}';

        BodyHTML_lTxt += '.invoice-box table tr.item td{';
        BodyHTML_lTxt += 'border-bottom: 1px solid #eee;';
        BodyHTML_lTxt += '}';

        BodyHTML_lTxt += '.invoice-box table tr.item.last td {';
        BodyHTML_lTxt += 'border-bottom: none;';
        BodyHTML_lTxt += '}';

        BodyHTML_lTxt += '.invoice-box table tr.total td:nth-child(2) {';
        BodyHTML_lTxt += 'border-top: 2px solid #eee;';
        BodyHTML_lTxt += 'font-weight: bold;';
        BodyHTML_lTxt += '}';

        BodyHTML_lTxt += '@media only screen and (max-width: 600px) {';
        BodyHTML_lTxt += '.invoice-box table tr.top table td {';
        BodyHTML_lTxt += 'width: 100%;';
        BodyHTML_lTxt += 'display: block;';
        BodyHTML_lTxt += 'text-align: center;';
        BodyHTML_lTxt += '}';

        BodyHTML_lTxt += '.invoice-box table tr.information table td {';
        BodyHTML_lTxt += 'width: 100%;';
        BodyHTML_lTxt += 'display: block;';
        BodyHTML_lTxt += 'text-align: center;';
        BodyHTML_lTxt += '}';
        BodyHTML_lTxt += '}';

        BodyHTML_lTxt += '/** RTL **/';
        BodyHTML_lTxt += '.rtl {';
        BodyHTML_lTxt += 'direction: rtl;';
        BodyHTML_lTxt += 'font-family: Tahoma, ''Helvetica Neue'', ''Helvetica'', Helvetica, Arial, sans-serif;';
        BodyHTML_lTxt += '}';

        BodyHTML_lTxt += '.rtl table {';
        BodyHTML_lTxt += 'text-align: right;';
        BodyHTML_lTxt += '}';

        BodyHTML_lTxt += '.rtl table tr td:nth-child(2) {';
        BodyHTML_lTxt += 'text-align: left;';
        BodyHTML_lTxt += '}';
        BodyHTML_lTxt += '</style>';
        BodyHTML_lTxt += '</head>';

        BodyHTML_lTxt += '<body>';
        BodyHTML_lTxt += '<div class="invoice-box">';
        BodyHTML_lTxt += '<table cellpadding="0" cellspacing="0">';
        BodyHTML_lTxt += '<tr class="top">';
        BodyHTML_lTxt += '<td colspan="2">';
        BodyHTML_lTxt += '<table>';
        BodyHTML_lTxt += '<tr>';
        BodyHTML_lTxt += '<td>';
        BodyHTML_lTxt += '<img src="https://106c4.wpc.azureedge.net/80106C4/Gallery-Prod/cdn/2015-02-24/prod20161101-microsoft-windowsazure-gallery/microsoftdynsmb.3a67602d-0a4f-4ae4-ad03-c1124f6ac3cf.1.0.2/Icon/large.png" height="100" width="100">';
        BodyHTML_lTxt += '</td>';

        BodyHTML_lTxt += '<td class="title">';
        BodyHTML_lTxt += '<b><font size = "5">Vendor Statement</font></b><br>';
        BodyHTML_lTxt += '</td>';
        BodyHTML_lTxt += '</tr>';
        BodyHTML_lTxt += '</table>';
        BodyHTML_lTxt += '</td>';
        BodyHTML_lTxt += '</tr>';

        BodyHTML_lTxt += '<tr class="information">';
        BodyHTML_lTxt += '<td colspan="2">';
        BodyHTML_lTxt += '<table>';
        BodyHTML_lTxt += '<tr>';
        BodyHTML_lTxt += '<td>';
        BodyHTML_lTxt += CompanyInfo.Name + '<br>';
        BodyHTML_lTxt += CompanyInfo.Address + '<br>';
        BodyHTML_lTxt += CompanyInfo."Address 2" + '<br>';
        BodyHTML_lTxt += CompanyInfo.City + '<br>';
        BodyHTML_lTxt += CompanyInfo."Post Code" + '<br>';
        BodyHTML_lTxt += CompanyInfo."Phone No." + '<br>';
        BodyHTML_lTxt += '</td>';

        BodyHTML_lTxt += '<td>';
        BodyHTML_lTxt += CompanyInfo."Contact Person" + '<br>';
        BodyHTML_lTxt += CompanyInfo."E-Mail" + '<br>';
        BodyHTML_lTxt += 'Created Date:' + Format(CurrentDateTime()) + '<br>';
        BodyHTML_lTxt += '</td>';
        BodyHTML_lTxt += '</tr>';
        BodyHTML_lTxt += '</table>';
        BodyHTML_lTxt += '</td>';
        BodyHTML_lTxt += '</tr>';

        BodyHTML_lTxt += '<tr class="heading">';
        BodyHTML_lTxt += '<td>';
        BodyHTML_lTxt += 'Account No.';
        BodyHTML_lTxt += '</td>';

        BodyHTML_lTxt += '<td>';
        BodyHTML_lTxt += Vendor_lRec."No.";
        BodyHTML_lTxt += '</td>';
        BodyHTML_lTxt += '</tr>';

        BodyHTML_lTxt += '<tr class="details">';
        BodyHTML_lTxt += '<td>';
        BodyHTML_lTxt += 'Name';
        BodyHTML_lTxt += '</td>';

        BodyHTML_lTxt += '<td>';
        BodyHTML_lTxt += Vendor_lRec.Name;
        BodyHTML_lTxt += '</td>';
        BodyHTML_lTxt += '</tr>';

        BodyHTML_lTxt += '<tr class="heading">';
        BodyHTML_lTxt += '<td>';
        BodyHTML_lTxt += 'Details:';
        BodyHTML_lTxt += '</td>';

        BodyHTML_lTxt += '<td>';
        BodyHTML_lTxt += '';
        BodyHTML_lTxt += '</td>';
        BodyHTML_lTxt += '</tr>';

        BodyHTML_lTxt += '<tr class="item">';
        BodyHTML_lTxt += '<td>';
        BodyHTML_lTxt += 'Period';
        BodyHTML_lTxt += '</td>';

        BodyHTML_lTxt += '<td>';
        BodyHTML_lTxt += 'From ' + Format(ConvertedStartDate) + ' To ' + Format(ConvertedEndDate);
        BodyHTML_lTxt += '</td>';
        BodyHTML_lTxt += '</tr>';

        BodyHTML_lTxt += '<tr class="item last">';
        BodyHTML_lTxt += '<td>';
        BodyHTML_lTxt += '';
        BodyHTML_lTxt += '</td>';

        BodyHTML_lTxt += '<td>';
        BodyHTML_lTxt += '</td>';
        BodyHTML_lTxt += '</tr>';

        BodyHTML_lTxt += '</table>';
        BodyHTML_lTxt += '</div>';
        BodyHTML_lTxt += '</body>';
        BodyHTML_lTxt += '</html>';
        BodyHTML_lTxt += '<br><br>Kindly go through attached Document for more details.';
        BodyHTML_lTxt += '<br><br>Regards,<br><b>';
        BodyHTML_lTxt += CompanyInfo."Contact Person" + '<br>';
        BodyHTML_lTxt += CompanyInfo.Name + '<br>';
        BodyHTML_lTxt += CompanyInfo.Address + '<br>';
        BodyHTML_lTxt += CompanyInfo."Address 2" + '<br>';
        BodyHTML_lTxt += CompanyInfo.City + ',';
        BodyHTML_lTxt += CompanyInfo."Post Code" + '<br>';
        BodyHTML_lTxt += CompanyInfo."Phone No." + '<br>';
        BodyHTML_lTxt += CompanyInfo."E-Mail" + '<br></b>';

        WebPortalSetup_gRec.Get();
        if WebPortalSetup_gRec."Email as CC for Cust/Vend" then begin
            Clear(Recepients);
            Recepients.Add(Vendor_lRec."E-Mail");
            CC.Add(Vendor_lRec."E-Mail");
        end;

        EmailMessage.Create(Recepients, 'D365 Business Central', BodyHTML_lTxt, true, CC, BCC);

        XMLParameter := '<?xml version="1.0" standalone="yes"?><ReportParameters name="Vendor Ledger" id="70144602"><Options><Field name="PrintDetail_gBln">false</Field><Field name="PrintLineNarration_gBln">false</Field><Field name="PrintVchNarration_gBln">false</Field><Field name="ShowAmtInLCY_gBln">false</Field><Field name="SortByName_gBln">false</Field></Options><DataItems><DataItem name="Vendor">VERSION(1) SORTING(Field1) WHERE(Field1=1(' + Vendor_lRec."No." + '),Field55=1(2012-01-01..2018-01-01))</DataItem><DataItem name="Detailed Vendor Ledg. Entry">VERSION(1) SORTING(Field9,Field4,Field6)</DataItem><DataItem name="G/L Entry">VERSION(1) SORTING(Field3,Field4)</DataItem></DataItems></ReportParameters>';

        TempBlob.CreateOutStream(EmailoutStream);
        TempBlob.CreateInStream(EmailInStream);

        Clear(VendorLedgerReport);
        VendorLedgerReport.SetParameter(ConvertedStartDate, ConvertedEndDate);

        VendorLedgerReport.SaveAs(XMLParameter, ReportFormat::Excel, EmailoutStream);

        EmailMessage.AddAttachment('VendorStatement' + VendorNo_iCod + '.xlsx', 'XLSX', EmailInStream);
        // if SMTPMail.TrySend() then begin
        //     Message('Email Sent Successfully');
        //     exit(true);
        // end;
        Clear(Email);
        if Email.Send(EmailMessage, Enum::"Email Scenario"::Default) then begin
            if GuiAllowed then
                Message('Email Sent Successfully');
            exit(true);
        end;
    end;

    procedure PrintVendorStatementD365_gFnc(VendorNo_iCod: Code[20]; StateDate_iTxt: Date; EndDate_iTxt: Date; UserID: Code[80]): Boolean
    var
        CompanyInfo: Record "Company Information";
        Vendor_lRec: Record Vendor;
        VendorLedgerReport: Report "INT Vendor Ledger";
        Email: Codeunit Email;
        EmailMessage: Codeunit "Email Message";
        TempBlob: Codeunit "Temp Blob";
        EmailInStream: InStream;
        BCC: List of [Text];
        CC: List of [Text];
        Recepients: List of [Text];
        EmailoutStream: OutStream;
        BodyHTML_lTxt: Text;
        XMLParameter: Text;
    begin
        if StateDate_iTxt = 0D then
            Error('Please select the Start Date');

        if EndDate_iTxt = 0D then
            Error('Please select the End Date');

        Vendor_lRec.Reset();
        Vendor_lRec.SetRange("No.", VendorNo_iCod);
        Vendor_lRec.SetFilter("Date Filter", '%1..%2', StateDate_iTxt, StateDate_iTxt);
        if not Vendor_lRec.FindFirst() then
            Error('Statement from Date %1 to %2 doesnot exists.', StateDate_iTxt, EndDate_iTxt);

        //XMLParameter := Report.RunRequestPage(70144602);
        Clear(CompanyInfo);
        CompanyInfo.Get();

        Recepients.Add(UserID);
        // SMTPMail.CreateMessage('Intech Systems Pvt. Ltd.', SMTPMailsetup."User ID", Recepients, 'D365 Business Central', '');

        BodyHTML_lTxt += '<html>';
        BodyHTML_lTxt += '<head>';
        BodyHTML_lTxt += '<meta charset="utf-8">';
        BodyHTML_lTxt += '<title>A simple, clean, and responsive HTML invoice template</title>';

        BodyHTML_lTxt += '<style>';
        BodyHTML_lTxt += '.invoice-box {';
        BodyHTML_lTxt += 'max-width: 800px;';
        BodyHTML_lTxt += 'margin: auto;';
        BodyHTML_lTxt += 'padding: 30px;';
        BodyHTML_lTxt += 'border: 1px solid #eee;';
        BodyHTML_lTxt += 'box-shadow: 0 0 10px rgba(0, 0, 0, .15;';
        BodyHTML_lTxt += 'font-size: 16px;';
        BodyHTML_lTxt += 'line-height: 24px;';
        BodyHTML_lTxt += 'font-family: ''Helvetica Neue'', ''Helvetica'', Helvetica, Arial, sans-serif;';
        BodyHTML_lTxt += 'color: #555;';
        BodyHTML_lTxt += '}';

        BodyHTML_lTxt += '.invoice-box table {';
        BodyHTML_lTxt += 'width: 100%;';
        BodyHTML_lTxt += 'line-height: inherit;';
        BodyHTML_lTxt += 'text-align: left;';
        BodyHTML_lTxt += '}';

        BodyHTML_lTxt += '.invoice-box table td {';
        BodyHTML_lTxt += 'padding: 5px;';
        BodyHTML_lTxt += 'vertical-align: top;';
        BodyHTML_lTxt += '}';

        BodyHTML_lTxt += '.invoice-box table tr td:nth-child(2) {';
        BodyHTML_lTxt += 'text-align: right;';
        BodyHTML_lTxt += '}';

        BodyHTML_lTxt += '.invoice-box table tr.top table td {';
        BodyHTML_lTxt += 'padding-bottom: 20px;';
        BodyHTML_lTxt += '}';

        BodyHTML_lTxt += '.invoice-box table tr.top table td.title {';
        BodyHTML_lTxt += 'font-size: 45px;';
        BodyHTML_lTxt += 'line-height: 45px;';
        BodyHTML_lTxt += 'color: #333;';
        BodyHTML_lTxt += '}';

        BodyHTML_lTxt += '.invoice-box table tr.information table td {';
        BodyHTML_lTxt += 'padding-bottom: 40px;';
        BodyHTML_lTxt += '}';

        BodyHTML_lTxt += '.invoice-box table tr.heading td {';
        BodyHTML_lTxt += 'background: #eee;';
        BodyHTML_lTxt += 'border-bottom: 1px solid #ddd;';
        BodyHTML_lTxt += 'font-weight: bold;';
        BodyHTML_lTxt += '}';

        BodyHTML_lTxt += '.invoice-box table tr.details td {';
        BodyHTML_lTxt += 'padding-bottom: 20px;';
        BodyHTML_lTxt += '}';

        BodyHTML_lTxt += '.invoice-box table tr.item td{';
        BodyHTML_lTxt += 'border-bottom: 1px solid #eee;';
        BodyHTML_lTxt += '}';

        BodyHTML_lTxt += '.invoice-box table tr.item.last td {';
        BodyHTML_lTxt += 'border-bottom: none;';
        BodyHTML_lTxt += '}';

        BodyHTML_lTxt += '.invoice-box table tr.total td:nth-child(2) {';
        BodyHTML_lTxt += 'border-top: 2px solid #eee;';
        BodyHTML_lTxt += 'font-weight: bold;';
        BodyHTML_lTxt += '}';

        BodyHTML_lTxt += '@media only screen and (max-width: 600px) {';
        BodyHTML_lTxt += '.invoice-box table tr.top table td {';
        BodyHTML_lTxt += 'width: 100%;';
        BodyHTML_lTxt += 'display: block;';
        BodyHTML_lTxt += 'text-align: center;';
        BodyHTML_lTxt += '}';

        BodyHTML_lTxt += '.invoice-box table tr.information table td {';
        BodyHTML_lTxt += 'width: 100%;';
        BodyHTML_lTxt += 'display: block;';
        BodyHTML_lTxt += 'text-align: center;';
        BodyHTML_lTxt += '}';
        BodyHTML_lTxt += '}';

        BodyHTML_lTxt += '/** RTL **/';
        BodyHTML_lTxt += '.rtl {';
        BodyHTML_lTxt += 'direction: rtl;';
        BodyHTML_lTxt += 'font-family: Tahoma, ''Helvetica Neue'', ''Helvetica'', Helvetica, Arial, sans-serif;';
        BodyHTML_lTxt += '}';

        BodyHTML_lTxt += '.rtl table {';
        BodyHTML_lTxt += 'text-align: right;';
        BodyHTML_lTxt += '}';

        BodyHTML_lTxt += '.rtl table tr td:nth-child(2) {';
        BodyHTML_lTxt += 'text-align: left;';
        BodyHTML_lTxt += '}';
        BodyHTML_lTxt += '</style>';
        BodyHTML_lTxt += '</head>';

        BodyHTML_lTxt += '<body>';
        BodyHTML_lTxt += '<div class="invoice-box">';
        BodyHTML_lTxt += '<table cellpadding="0" cellspacing="0">';
        BodyHTML_lTxt += '<tr class="top">';
        BodyHTML_lTxt += '<td colspan="2">';
        BodyHTML_lTxt += '<table>';
        BodyHTML_lTxt += '<tr>';
        BodyHTML_lTxt += '<td>';
        BodyHTML_lTxt += '<img src="https://106c4.wpc.azureedge.net/80106C4/Gallery-Prod/cdn/2015-02-24/prod20161101-microsoft-windowsazure-gallery/microsoftdynsmb.3a67602d-0a4f-4ae4-ad03-c1124f6ac3cf.1.0.2/Icon/large.png" height="100" width="100">';
        BodyHTML_lTxt += '</td>';

        BodyHTML_lTxt += '<td class="title">';
        BodyHTML_lTxt += '<b><font size = "5">Vendor Statement</font></b><br>';
        BodyHTML_lTxt += '</td>';
        BodyHTML_lTxt += '</tr>';
        BodyHTML_lTxt += '</table>';
        BodyHTML_lTxt += '</td>';
        BodyHTML_lTxt += '</tr>';

        BodyHTML_lTxt += '<tr class="information">';
        BodyHTML_lTxt += '<td colspan="2">';
        BodyHTML_lTxt += '<table>';
        BodyHTML_lTxt += '<tr>';
        BodyHTML_lTxt += '<td>';
        BodyHTML_lTxt += CompanyInfo.Name + '<br>';
        BodyHTML_lTxt += CompanyInfo.Address + '<br>';
        BodyHTML_lTxt += CompanyInfo."Address 2" + '<br>';
        BodyHTML_lTxt += CompanyInfo.City + '<br>';
        BodyHTML_lTxt += CompanyInfo."Post Code" + '<br>';
        BodyHTML_lTxt += CompanyInfo."Phone No." + '<br>';
        BodyHTML_lTxt += '</td>';

        BodyHTML_lTxt += '<td>';
        BodyHTML_lTxt += CompanyInfo."Contact Person" + '<br>';
        BodyHTML_lTxt += CompanyInfo."E-Mail" + '<br>';
        BodyHTML_lTxt += 'Created Date:' + Format(CurrentDateTime()) + '<br>';
        BodyHTML_lTxt += '</td>';
        BodyHTML_lTxt += '</tr>';
        BodyHTML_lTxt += '</table>';
        BodyHTML_lTxt += '</td>';
        BodyHTML_lTxt += '</tr>';

        BodyHTML_lTxt += '<tr class="heading">';
        BodyHTML_lTxt += '<td>';
        BodyHTML_lTxt += 'Account No.';
        BodyHTML_lTxt += '</td>';

        BodyHTML_lTxt += '<td>';
        BodyHTML_lTxt += Vendor_lRec."No.";
        BodyHTML_lTxt += '</td>';
        BodyHTML_lTxt += '</tr>';

        BodyHTML_lTxt += '<tr class="details">';
        BodyHTML_lTxt += '<td>';
        BodyHTML_lTxt += 'Name';
        BodyHTML_lTxt += '</td>';

        BodyHTML_lTxt += '<td>';
        BodyHTML_lTxt += Vendor_lRec.Name;
        BodyHTML_lTxt += '</td>';
        BodyHTML_lTxt += '</tr>';

        BodyHTML_lTxt += '<tr class="heading">';
        BodyHTML_lTxt += '<td>';
        BodyHTML_lTxt += 'Details:';
        BodyHTML_lTxt += '</td>';

        BodyHTML_lTxt += '<td>';
        BodyHTML_lTxt += '';
        BodyHTML_lTxt += '</td>';
        BodyHTML_lTxt += '</tr>';

        BodyHTML_lTxt += '<tr class="item">';
        BodyHTML_lTxt += '<td>';
        BodyHTML_lTxt += 'Period';
        BodyHTML_lTxt += '</td>';

        BodyHTML_lTxt += '<td>';
        BodyHTML_lTxt += 'From ' + Format(StateDate_iTxt) + ' To ' + Format(EndDate_iTxt);
        BodyHTML_lTxt += '</td>';
        BodyHTML_lTxt += '</tr>';

        BodyHTML_lTxt += '<tr class="item last">';
        BodyHTML_lTxt += '<td>';
        BodyHTML_lTxt += '';
        BodyHTML_lTxt += '</td>';

        BodyHTML_lTxt += '<td>';
        BodyHTML_lTxt += '</td>';
        BodyHTML_lTxt += '</tr>';

        BodyHTML_lTxt += '</table>';
        BodyHTML_lTxt += '</div>';
        BodyHTML_lTxt += '</body>';
        BodyHTML_lTxt += '</html>';
        BodyHTML_lTxt += '<br><br>Kindly go through attached Document for more details.';
        BodyHTML_lTxt += '<br><br>Regards,<br><b>';
        BodyHTML_lTxt += CompanyInfo."Contact Person" + '<br>';
        BodyHTML_lTxt += CompanyInfo.Name + '<br>';
        BodyHTML_lTxt += CompanyInfo.Address + '<br>';
        BodyHTML_lTxt += CompanyInfo."Address 2" + '<br>';
        BodyHTML_lTxt += CompanyInfo.City + ',';
        BodyHTML_lTxt += CompanyInfo."Post Code" + '<br>';
        BodyHTML_lTxt += CompanyInfo."Phone No." + '<br>';
        BodyHTML_lTxt += CompanyInfo."E-Mail" + '<br></b>';

        WebPortalSetup_gRec.Get();
        if WebPortalSetup_gRec."Email as CC for Cust/Vend" then begin
            Clear(Recepients);
            Recepients.Add(Vendor_lRec."E-Mail");
            CC.Add(Vendor_lRec."E-Mail");
        end;

        EmailMessage.Create(Recepients, 'D365 Business Central', BodyHTML_lTxt, true, CC, BCC);

        XMLParameter := '<?xml version="1.0" standalone="yes"?><ReportParameters name="Vendor Ledger" id="70144602"><Options><Field name="PrintDetail_gBln">false</Field><Field name="PrintLineNarration_gBln">false</Field><Field name="PrintVchNarration_gBln">false</Field><Field name="ShowAmtInLCY_gBln">false</Field><Field name="SortByName_gBln">false</Field></Options><DataItems><DataItem name="Vendor">VERSION(1) SORTING(Field1) WHERE(Field1=1(' + Vendor_lRec."No." + '),Field55=1(2012-01-01..2018-01-01))</DataItem><DataItem name="Detailed Vendor Ledg. Entry">VERSION(1) SORTING(Field9,Field4,Field6)</DataItem><DataItem name="G/L Entry">VERSION(1) SORTING(Field3,Field4)</DataItem></DataItems></ReportParameters>';

        TempBlob.CreateOutStream(EmailoutStream);
        TempBlob.CreateInStream(EmailInStream);

        Clear(VendorLedgerReport);
        VendorLedgerReport.SetParameter(StateDate_iTxt, EndDate_iTxt);

        VendorLedgerReport.SaveAs(XMLParameter, ReportFormat::Pdf, EmailoutStream);
        EmailMessage.AddAttachment('VendorStatement' + VendorNo_iCod + '.pdf', 'PDF', EmailInStream);

        // if SMTPMail.TrySend() then begin
        //     Message('Email Sent Successfully');
        //     exit(true);
        // end;
        Clear(Email);
        if Email.Send(EmailMessage, Enum::"Email Scenario"::Default) then begin
            if GuiAllowed then
                Message('Email Sent Successfully');
            exit(true);
        end;
    end;

    procedure PrintVendorStatementEXCELD365_gFnc(VendorNo_iCod: Code[20]; StateDate_iTxt: Date; EndDate_iTxt: Date; UserID: Code[80]): Boolean
    var
        CompanyInfo: Record "Company Information";
        Vendor_lRec: Record Vendor;
        VendorLedgerReport: Report "INT Vendor Ledger";
        Email: Codeunit Email;
        EmailMessage: Codeunit "Email Message";
        TempBlob: Codeunit "Temp Blob";
        EmailInStream: InStream;
        BCC: List of [Text];
        CC: List of [Text];
        Recepients: List of [Text];
        EmailoutStream: OutStream;
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

        //XMLParameter := Report.RunRequestPage(70144602);
        Clear(CompanyInfo);
        CompanyInfo.Get();


        Recepients.Add(UserID);
        //SMTPMail.CreateMessage('Intech Systems Pvt. Ltd.', SMTPMailsetup."User ID", Recepients, 'D365 Business Central', '');

        BodyHTML_lTxt += '<html>';
        BodyHTML_lTxt += '<head>';
        BodyHTML_lTxt += '<meta charset="utf-8">';
        BodyHTML_lTxt += '<title>A simple, clean, and responsive HTML invoice template</title>';

        BodyHTML_lTxt += '<style>';
        BodyHTML_lTxt += '.invoice-box {';
        BodyHTML_lTxt += 'max-width: 800px;';
        BodyHTML_lTxt += 'margin: auto;';
        BodyHTML_lTxt += 'padding: 30px;';
        BodyHTML_lTxt += 'border: 1px solid #eee;';
        BodyHTML_lTxt += 'box-shadow: 0 0 10px rgba(0, 0, 0, .15;';
        BodyHTML_lTxt += 'font-size: 16px;';
        BodyHTML_lTxt += 'line-height: 24px;';
        BodyHTML_lTxt += 'font-family: ''Helvetica Neue'', ''Helvetica'', Helvetica, Arial, sans-serif;';
        BodyHTML_lTxt += 'color: #555;';
        BodyHTML_lTxt += '}';

        BodyHTML_lTxt += '.invoice-box table {';
        BodyHTML_lTxt += 'width: 100%;';
        BodyHTML_lTxt += 'line-height: inherit;';
        BodyHTML_lTxt += 'text-align: left;';
        BodyHTML_lTxt += '}';

        BodyHTML_lTxt += '.invoice-box table td {';
        BodyHTML_lTxt += 'padding: 5px;';
        BodyHTML_lTxt += 'vertical-align: top;';
        BodyHTML_lTxt += '}';

        BodyHTML_lTxt += '.invoice-box table tr td:nth-child(2) {';
        BodyHTML_lTxt += 'text-align: right;';
        BodyHTML_lTxt += '}';

        BodyHTML_lTxt += '.invoice-box table tr.top table td {';
        BodyHTML_lTxt += 'padding-bottom: 20px;';
        BodyHTML_lTxt += '}';

        BodyHTML_lTxt += '.invoice-box table tr.top table td.title {';
        BodyHTML_lTxt += 'font-size: 45px;';
        BodyHTML_lTxt += 'line-height: 45px;';
        BodyHTML_lTxt += 'color: #333;';
        BodyHTML_lTxt += '}';

        BodyHTML_lTxt += '.invoice-box table tr.information table td {';
        BodyHTML_lTxt += 'padding-bottom: 40px;';
        BodyHTML_lTxt += '}';

        BodyHTML_lTxt += '.invoice-box table tr.heading td {';
        BodyHTML_lTxt += 'background: #eee;';
        BodyHTML_lTxt += 'border-bottom: 1px solid #ddd;';
        BodyHTML_lTxt += 'font-weight: bold;';
        BodyHTML_lTxt += '}';

        BodyHTML_lTxt += '.invoice-box table tr.details td {';
        BodyHTML_lTxt += 'padding-bottom: 20px;';
        BodyHTML_lTxt += '}';

        BodyHTML_lTxt += '.invoice-box table tr.item td{';
        BodyHTML_lTxt += 'border-bottom: 1px solid #eee;';
        BodyHTML_lTxt += '}';

        BodyHTML_lTxt += '.invoice-box table tr.item.last td {';
        BodyHTML_lTxt += 'border-bottom: none;';
        BodyHTML_lTxt += '}';

        BodyHTML_lTxt += '.invoice-box table tr.total td:nth-child(2) {';
        BodyHTML_lTxt += 'border-top: 2px solid #eee;';
        BodyHTML_lTxt += 'font-weight: bold;';
        BodyHTML_lTxt += '}';

        BodyHTML_lTxt += '@media only screen and (max-width: 600px) {';
        BodyHTML_lTxt += '.invoice-box table tr.top table td {';
        BodyHTML_lTxt += 'width: 100%;';
        BodyHTML_lTxt += 'display: block;';
        BodyHTML_lTxt += 'text-align: center;';
        BodyHTML_lTxt += '}';

        BodyHTML_lTxt += '.invoice-box table tr.information table td {';
        BodyHTML_lTxt += 'width: 100%;';
        BodyHTML_lTxt += 'display: block;';
        BodyHTML_lTxt += 'text-align: center;';
        BodyHTML_lTxt += '}';
        BodyHTML_lTxt += '}';

        BodyHTML_lTxt += '/** RTL **/';
        BodyHTML_lTxt += '.rtl {';
        BodyHTML_lTxt += 'direction: rtl;';
        BodyHTML_lTxt += 'font-family: Tahoma, ''Helvetica Neue'', ''Helvetica'', Helvetica, Arial, sans-serif;';
        BodyHTML_lTxt += '}';

        BodyHTML_lTxt += '.rtl table {';
        BodyHTML_lTxt += 'text-align: right;';
        BodyHTML_lTxt += '}';

        BodyHTML_lTxt += '.rtl table tr td:nth-child(2) {';
        BodyHTML_lTxt += 'text-align: left;';
        BodyHTML_lTxt += '}';
        BodyHTML_lTxt += '</style>';
        BodyHTML_lTxt += '</head>';

        BodyHTML_lTxt += '<body>';
        BodyHTML_lTxt += '<div class="invoice-box">';
        BodyHTML_lTxt += '<table cellpadding="0" cellspacing="0">';
        BodyHTML_lTxt += '<tr class="top">';
        BodyHTML_lTxt += '<td colspan="2">';
        BodyHTML_lTxt += '<table>';
        BodyHTML_lTxt += '<tr>';
        BodyHTML_lTxt += '<td>';
        BodyHTML_lTxt += '<img src="https://106c4.wpc.azureedge.net/80106C4/Gallery-Prod/cdn/2015-02-24/prod20161101-microsoft-windowsazure-gallery/microsoftdynsmb.3a67602d-0a4f-4ae4-ad03-c1124f6ac3cf.1.0.2/Icon/large.png" height="100" width="100">';
        BodyHTML_lTxt += '</td>';

        BodyHTML_lTxt += '<td class="title">';
        BodyHTML_lTxt += '<b><font size = "5">Vendor Statement</font></b><br>';
        BodyHTML_lTxt += '</td>';
        BodyHTML_lTxt += '</tr>';
        BodyHTML_lTxt += '</table>';
        BodyHTML_lTxt += '</td>';
        BodyHTML_lTxt += '</tr>';

        BodyHTML_lTxt += '<tr class="information">';
        BodyHTML_lTxt += '<td colspan="2">';
        BodyHTML_lTxt += '<table>';
        BodyHTML_lTxt += '<tr>';
        BodyHTML_lTxt += '<td>';
        BodyHTML_lTxt += CompanyInfo.Name + '<br>';
        BodyHTML_lTxt += CompanyInfo.Address + '<br>';
        BodyHTML_lTxt += CompanyInfo."Address 2" + '<br>';
        BodyHTML_lTxt += CompanyInfo.City + '<br>';
        BodyHTML_lTxt += CompanyInfo."Post Code" + '<br>';
        BodyHTML_lTxt += CompanyInfo."Phone No." + '<br>';
        BodyHTML_lTxt += '</td>';

        BodyHTML_lTxt += '<td>';
        BodyHTML_lTxt += CompanyInfo."Contact Person" + '<br>';
        BodyHTML_lTxt += CompanyInfo."E-Mail" + '<br>';
        BodyHTML_lTxt += 'Created Date:' + Format(CurrentDateTime()) + '<br>';
        BodyHTML_lTxt += '</td>';
        BodyHTML_lTxt += '</tr>';
        BodyHTML_lTxt += '</table>';
        BodyHTML_lTxt += '</td>';
        BodyHTML_lTxt += '</tr>';

        BodyHTML_lTxt += '<tr class="heading">';
        BodyHTML_lTxt += '<td>';
        BodyHTML_lTxt += 'Account No.';
        BodyHTML_lTxt += '</td>';

        BodyHTML_lTxt += '<td>';
        BodyHTML_lTxt += Vendor_lRec."No.";
        BodyHTML_lTxt += '</td>';
        BodyHTML_lTxt += '</tr>';

        BodyHTML_lTxt += '<tr class="details">';
        BodyHTML_lTxt += '<td>';
        BodyHTML_lTxt += 'Name';
        BodyHTML_lTxt += '</td>';

        BodyHTML_lTxt += '<td>';
        BodyHTML_lTxt += Vendor_lRec.Name;
        BodyHTML_lTxt += '</td>';
        BodyHTML_lTxt += '</tr>';

        BodyHTML_lTxt += '<tr class="heading">';
        BodyHTML_lTxt += '<td>';
        BodyHTML_lTxt += 'Details:';
        BodyHTML_lTxt += '</td>';

        BodyHTML_lTxt += '<td>';
        BodyHTML_lTxt += '';
        BodyHTML_lTxt += '</td>';
        BodyHTML_lTxt += '</tr>';

        BodyHTML_lTxt += '<tr class="item">';
        BodyHTML_lTxt += '<td>';
        BodyHTML_lTxt += 'Period';
        BodyHTML_lTxt += '</td>';

        BodyHTML_lTxt += '<td>';
        BodyHTML_lTxt += 'From ' + Format(StateDate_iTxt) + ' To ' + Format(EndDate_iTxt);
        BodyHTML_lTxt += '</td>';
        BodyHTML_lTxt += '</tr>';

        BodyHTML_lTxt += '<tr class="item last">';
        BodyHTML_lTxt += '<td>';
        BodyHTML_lTxt += '';
        BodyHTML_lTxt += '</td>';

        BodyHTML_lTxt += '<td>';
        BodyHTML_lTxt += '</td>';
        BodyHTML_lTxt += '</tr>';

        BodyHTML_lTxt += '</table>';
        BodyHTML_lTxt += '</div>';
        BodyHTML_lTxt += '</body>';
        BodyHTML_lTxt += '</html>';
        BodyHTML_lTxt += '<br><br>Kindly go through attached Document for more details.';
        BodyHTML_lTxt += '<br><br>Regards,<br><b>';
        BodyHTML_lTxt += CompanyInfo."Contact Person" + '<br>';
        BodyHTML_lTxt += CompanyInfo.Name + '<br>';
        BodyHTML_lTxt += CompanyInfo.Address + '<br>';
        BodyHTML_lTxt += CompanyInfo."Address 2" + '<br>';
        BodyHTML_lTxt += CompanyInfo.City + ',';
        BodyHTML_lTxt += CompanyInfo."Post Code" + '<br>';
        BodyHTML_lTxt += CompanyInfo."Phone No." + '<br>';
        BodyHTML_lTxt += CompanyInfo."E-Mail" + '<br></b>';

        WebPortalSetup_gRec.Get();
        if WebPortalSetup_gRec."Email as CC for Cust/Vend" then begin
            Clear(Recepients);
            Recepients.Add(Vendor_lRec."E-Mail");
            CC.Add(Vendor_lRec."E-Mail");
        end;

        EmailMessage.Create(Recepients, 'D365 Business Central', BodyHTML_lTxt, true, CC, BCC);
        XMLParameter := '<?xml version="1.0" standalone="yes"?><ReportParameters name="Vendor Ledger" id="70144602"><Options><Field name="PrintDetail_gBln">false</Field><Field name="PrintLineNarration_gBln">false</Field><Field name="PrintVchNarration_gBln">false</Field><Field name="ShowAmtInLCY_gBln">false</Field><Field name="SortByName_gBln">false</Field></Options><DataItems><DataItem name="Vendor">VERSION(1) SORTING(Field1) WHERE(Field1=1(' + Vendor_lRec."No." + '),Field55=1(2012-01-01..2018-01-01))</DataItem><DataItem name="Detailed Vendor Ledg. Entry">VERSION(1) SORTING(Field9,Field4,Field6)</DataItem><DataItem name="G/L Entry">VERSION(1) SORTING(Field3,Field4)</DataItem></DataItems></ReportParameters>';

        TempBlob.CreateOutStream(EmailoutStream);
        Clear(VendorLedgerReport);
        VendorLedgerReport.SetParameter(StateDate_iTxt, EndDate_iTxt);

        VendorLedgerReport.SaveAs(XMLParameter, ReportFormat::Excel, EmailoutStream);
        TempBlob.CreateInStream(EmailInStream);
        EmailMessage.AddAttachment('VendorStatement' + VendorNo_iCod + '.xlsx', 'XLSX', EmailInStream);

        // if SMTPMail.TrySend() then begin
        //     Message('Email Sent Successfully');
        //     exit(true);
        // end;
        Clear(Email);
        if Email.Send(EmailMessage, Enum::"Email Scenario"::Default) then begin
            if GuiAllowed then
                Message('Email Sent Successfully');
            exit(true);
        end;
    end;

    procedure PrintCustomerPayments_gFnc(DocumentNo_iCod: Code[20]; UserID: Code[80]): Boolean
    var
        CompanyInfo: Record "Company Information";
        CustLedgEntry: Record "Cust. Ledger Entry";
        Customer: Record Customer;
        Email: Codeunit Email;
        EmailMessage: Codeunit "Email Message";
        TempBlob: Codeunit "Temp Blob";
        EmailInStream: InStream;
        BCC: List of [Text];
        CC: List of [Text];
        Recepients: List of [Text];
        EmailoutStream: OutStream;
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

        //XMLParameter := Report.RunRequestPage(211);


        Clear(CompanyInfo);
        CompanyInfo.Get();


        Recepients.Add(UserID);
        //SMTPMail.CreateMessage('Intech Systems Pvt. Ltd.', SMTPMailsetup."User ID", Recepients, 'D365 Business Central', '');

        BodyHTML_lTxt += '<html>';
        BodyHTML_lTxt += '<head>';
        BodyHTML_lTxt += '<meta charset="utf-8">';
        BodyHTML_lTxt += '<title>A simple, clean, and responsive HTML invoice template</title>';

        BodyHTML_lTxt += '<style>';
        BodyHTML_lTxt += '.invoice-box {';
        BodyHTML_lTxt += 'max-width: 800px;';
        BodyHTML_lTxt += 'margin: auto;';
        BodyHTML_lTxt += 'padding: 30px;';
        BodyHTML_lTxt += 'border: 1px solid #eee;';
        BodyHTML_lTxt += 'box-shadow: 0 0 10px rgba(0, 0, 0, .15;';
        BodyHTML_lTxt += 'font-size: 16px;';
        BodyHTML_lTxt += 'line-height: 24px;';
        BodyHTML_lTxt += 'font-family: ''Helvetica Neue'', ''Helvetica'', Helvetica, Arial, sans-serif;';
        BodyHTML_lTxt += 'color: #555;';
        BodyHTML_lTxt += '}';

        BodyHTML_lTxt += '.invoice-box table {';
        BodyHTML_lTxt += 'width: 100%;';
        BodyHTML_lTxt += 'line-height: inherit;';
        BodyHTML_lTxt += 'text-align: left;';
        BodyHTML_lTxt += '}';

        BodyHTML_lTxt += '.invoice-box table td {';
        BodyHTML_lTxt += 'padding: 5px;';
        BodyHTML_lTxt += 'vertical-align: top;';
        BodyHTML_lTxt += '}';

        BodyHTML_lTxt += '.invoice-box table tr td:nth-child(2) {';
        BodyHTML_lTxt += 'text-align: right;';
        BodyHTML_lTxt += '}';

        BodyHTML_lTxt += '.invoice-box table tr.top table td {';
        BodyHTML_lTxt += 'padding-bottom: 20px;';
        BodyHTML_lTxt += '}';

        BodyHTML_lTxt += '.invoice-box table tr.top table td.title {';
        BodyHTML_lTxt += 'font-size: 45px;';
        BodyHTML_lTxt += 'line-height: 45px;';
        BodyHTML_lTxt += 'color: #333;';
        BodyHTML_lTxt += '}';

        BodyHTML_lTxt += '.invoice-box table tr.information table td {';
        BodyHTML_lTxt += 'padding-bottom: 40px;';
        BodyHTML_lTxt += '}';

        BodyHTML_lTxt += '.invoice-box table tr.heading td {';
        BodyHTML_lTxt += 'background: #eee;';
        BodyHTML_lTxt += 'border-bottom: 1px solid #ddd;';
        BodyHTML_lTxt += 'font-weight: bold;';
        BodyHTML_lTxt += '}';

        BodyHTML_lTxt += '.invoice-box table tr.details td {';
        BodyHTML_lTxt += 'padding-bottom: 20px;';
        BodyHTML_lTxt += '}';

        BodyHTML_lTxt += '.invoice-box table tr.item td{';
        BodyHTML_lTxt += 'border-bottom: 1px solid #eee;';
        BodyHTML_lTxt += '}';

        BodyHTML_lTxt += '.invoice-box table tr.item.last td {';
        BodyHTML_lTxt += 'border-bottom: none;';
        BodyHTML_lTxt += '}';

        BodyHTML_lTxt += '.invoice-box table tr.total td:nth-child(2) {';
        BodyHTML_lTxt += 'border-top: 2px solid #eee;';
        BodyHTML_lTxt += 'font-weight: bold;';
        BodyHTML_lTxt += '}';

        BodyHTML_lTxt += '@media only screen and (max-width: 600px) {';
        BodyHTML_lTxt += '.invoice-box table tr.top table td {';
        BodyHTML_lTxt += 'width: 100%;';
        BodyHTML_lTxt += 'display: block;';
        BodyHTML_lTxt += 'text-align: center;';
        BodyHTML_lTxt += '}';

        BodyHTML_lTxt += '.invoice-box table tr.information table td {';
        BodyHTML_lTxt += 'width: 100%;';
        BodyHTML_lTxt += 'display: block;';
        BodyHTML_lTxt += 'text-align: center;';
        BodyHTML_lTxt += '}';
        BodyHTML_lTxt += '}';

        BodyHTML_lTxt += '/** RTL **/';
        BodyHTML_lTxt += '.rtl {';
        BodyHTML_lTxt += 'direction: rtl;';
        BodyHTML_lTxt += 'font-family: Tahoma, ''Helvetica Neue'', ''Helvetica'', Helvetica, Arial, sans-serif;';
        BodyHTML_lTxt += '}';

        BodyHTML_lTxt += '.rtl table {';
        BodyHTML_lTxt += 'text-align: right;';
        BodyHTML_lTxt += '}';

        BodyHTML_lTxt += '.rtl table tr td:nth-child(2) {';
        BodyHTML_lTxt += 'text-align: left;';
        BodyHTML_lTxt += '}';
        BodyHTML_lTxt += '</style>';
        BodyHTML_lTxt += '</head>';

        BodyHTML_lTxt += '<body>';
        BodyHTML_lTxt += '<div class="invoice-box">';
        BodyHTML_lTxt += '<table cellpadding="0" cellspacing="0">';
        BodyHTML_lTxt += '<tr class="top">';
        BodyHTML_lTxt += '<td colspan="2">';
        BodyHTML_lTxt += '<table>';
        BodyHTML_lTxt += '<tr>';
        BodyHTML_lTxt += '<td>';
        BodyHTML_lTxt += '<img src="https://106c4.wpc.azureedge.net/80106C4/Gallery-Prod/cdn/2015-02-24/prod20161101-microsoft-windowsazure-gallery/microsoftdynsmb.3a67602d-0a4f-4ae4-ad03-c1124f6ac3cf.1.0.2/Icon/large.png" height="100" width="100">';
        BodyHTML_lTxt += '</td>';

        BodyHTML_lTxt += '<td class="title">';
        BodyHTML_lTxt += '<b><font size = "5">Customer Payments</font></b><br>';
        BodyHTML_lTxt += '</td>';
        BodyHTML_lTxt += '</tr>';
        BodyHTML_lTxt += '</table>';
        BodyHTML_lTxt += '</td>';
        BodyHTML_lTxt += '</tr>';

        BodyHTML_lTxt += '<tr class="information">';
        BodyHTML_lTxt += '<td colspan="2">';
        BodyHTML_lTxt += '<table>';
        BodyHTML_lTxt += '<tr>';
        BodyHTML_lTxt += '<td>';
        BodyHTML_lTxt += CompanyInfo.Name + '<br>';
        BodyHTML_lTxt += CompanyInfo.Address + '<br>';
        BodyHTML_lTxt += CompanyInfo."Address 2" + '<br>';
        BodyHTML_lTxt += CompanyInfo.City + '<br>';
        BodyHTML_lTxt += CompanyInfo."Post Code" + '<br>';
        BodyHTML_lTxt += CompanyInfo."Phone No." + '<br>';
        BodyHTML_lTxt += '</td>';

        BodyHTML_lTxt += '<td>';
        BodyHTML_lTxt += CompanyInfo."Contact Person" + '<br>';
        BodyHTML_lTxt += CompanyInfo."E-Mail" + '<br>';
        BodyHTML_lTxt += 'Created Date:' + Format(CurrentDateTime()) + '<br>';
        BodyHTML_lTxt += '</td>';
        BodyHTML_lTxt += '</tr>';
        BodyHTML_lTxt += '</table>';
        BodyHTML_lTxt += '</td>';
        BodyHTML_lTxt += '</tr>';

        BodyHTML_lTxt += '<tr class="heading">';
        BodyHTML_lTxt += '<td>';
        BodyHTML_lTxt += 'Account No.';
        BodyHTML_lTxt += '</td>';

        BodyHTML_lTxt += '<td>';
        BodyHTML_lTxt += Customer."No.";
        BodyHTML_lTxt += '</td>';
        BodyHTML_lTxt += '</tr>';

        BodyHTML_lTxt += '<tr class="details">';
        BodyHTML_lTxt += '<td>';
        BodyHTML_lTxt += 'Name';
        BodyHTML_lTxt += '</td>';

        BodyHTML_lTxt += '<td>';
        BodyHTML_lTxt += Customer.Name;
        BodyHTML_lTxt += '</td>';
        BodyHTML_lTxt += '</tr>';

        BodyHTML_lTxt += '<tr class="heading">';
        BodyHTML_lTxt += '<td>';
        BodyHTML_lTxt += 'Details:';
        BodyHTML_lTxt += '</td>';

        BodyHTML_lTxt += '<td>';
        BodyHTML_lTxt += '';
        BodyHTML_lTxt += '</td>';
        BodyHTML_lTxt += '</tr>';

        BodyHTML_lTxt += '<tr class="item">';
        BodyHTML_lTxt += '<td>';
        BodyHTML_lTxt += 'Document No.';
        BodyHTML_lTxt += '</td>';

        BodyHTML_lTxt += '<td>';
        BodyHTML_lTxt += DocumentNo_iCod;
        BodyHTML_lTxt += '</td>';
        BodyHTML_lTxt += '</tr>';

        BodyHTML_lTxt += '<tr class="item">';
        BodyHTML_lTxt += '<td>';
        BodyHTML_lTxt += 'Order Date';
        BodyHTML_lTxt += '</td>';

        BodyHTML_lTxt += '<td>';
        BodyHTML_lTxt += Format(CustLedgEntry."Posting Date");
        BodyHTML_lTxt += '</td>';
        BodyHTML_lTxt += '</tr>';

        BodyHTML_lTxt += '<tr class="item last">';
        BodyHTML_lTxt += '<td>';
        BodyHTML_lTxt += '';
        BodyHTML_lTxt += '</td>';

        BodyHTML_lTxt += '<td>';
        BodyHTML_lTxt += '</td>';
        BodyHTML_lTxt += '</tr>';

        BodyHTML_lTxt += '<tr class="heading">';
        BodyHTML_lTxt += '<td>';
        BodyHTML_lTxt += 'Total';
        BodyHTML_lTxt += '</td>';

        BodyHTML_lTxt += '<td>';
        BodyHTML_lTxt += Format(CustLedgEntry.Amount);
        BodyHTML_lTxt += '</td>';
        BodyHTML_lTxt += '</tr>';

        BodyHTML_lTxt += '</table>';
        BodyHTML_lTxt += '</div>';
        BodyHTML_lTxt += '</body>';
        BodyHTML_lTxt += '</html>';
        BodyHTML_lTxt += '<br><br>Kindly go through attached Document for more details.';
        BodyHTML_lTxt += '<br><br>Regards,<br><b>';
        BodyHTML_lTxt += CompanyInfo."Contact Person" + '<br>';
        BodyHTML_lTxt += CompanyInfo.Name + '<br>';
        BodyHTML_lTxt += CompanyInfo.Address + '<br>';
        BodyHTML_lTxt += CompanyInfo."Address 2" + '<br>';
        BodyHTML_lTxt += CompanyInfo.City + ',';
        BodyHTML_lTxt += CompanyInfo."Post Code" + '<br>';
        BodyHTML_lTxt += CompanyInfo."Phone No." + '<br>';
        BodyHTML_lTxt += CompanyInfo."E-Mail" + '<br></b>';

        WebPortalSetup_gRec.Get();
        if WebPortalSetup_gRec."Email as CC for Cust/Vend" then begin
            Clear(Recepients);
            Recepients.Add(Customer."E-Mail");
            CC.Add(Customer."E-Mail");
        end;

        EmailMessage.Create(Recepients, 'D365 Business Central', BodyHTML_lTxt, true, CC, BCC);
        XMLParameter := '<?xml version="1.0" standalone="yes"?><ReportParameters name="Customer - Payment Receipt" id="211"><DataItems><DataItem name="Cust. Ledger Entry">VERSION(1) SORTING(Field5,Field3,Field4,Field11) WHERE(Field6=1(' + CustLedgEntry."Document No." + '))</DataItem><DataItem name="PageLoop">VERSION(1) SORTING(Field1)</DataItem><DataItem name="DetailedCustLedgEntry1">VERSION(1) SORTING(Field36,Field3)</DataItem><DataItem name="CustLedgEntry1">VERSION(1) SORTING(Field1)</DataItem><DataItem name="DetailedCustLedgEntry2">VERSION(1) SORTING(Field2,Field3,Field4)</DataItem><DataItem name="CustLedgEntry2">VERSION(1) SORTING(Field1)</DataItem><DataItem name="Total">VERSION(1) SORTING(Field1)</DataItem></DataItems></ReportParameters>';
        TempBlob.CreateOutStream(EmailoutStream);
        Report.SaveAs(211, XMLParameter, ReportFormat::Pdf, EmailoutStream);
        TempBlob.CreateInStream(EmailInStream);
        EmailMessage.AddAttachment('CustomerPaymentReceipt' + DocumentNo_iCod + '.pdf', 'PDF', EmailInStream);

        // if SMTPMail.TrySend() then begin
        //     Message('Email Sent Successfully');
        //     exit(true);
        // end;
        Clear(Email);
        if Email.Send(EmailMessage, Enum::"Email Scenario"::Default) then begin
            if GuiAllowed then
                Message('Email Sent Successfully');
            exit(true);
        end;
    end;

    procedure PrintVendorPayments_gFnc(DocumentNo_iCod: Code[20]; UserID: Code[80]): Boolean
    var
        CompanyInfo: Record "Company Information";
        Vendor: Record Vendor;
        VendLedgEntry: Record "Vendor Ledger Entry";
        Email: Codeunit Email;
        EmailMessage: Codeunit "Email Message";
        TempBlob: Codeunit "Temp Blob";
        EmailInStream: InStream;
        BCC: List of [Text];
        CC: List of [Text];
        Recepients: List of [Text];
        EmailoutStream: OutStream;
        BodyHTML_lTxt: Text;
        XMLParameter: Text;
    begin
        VendLedgEntry.Reset();
        VendLedgEntry.SetRange("Document No.", DocumentNo_iCod);
        if not VendLedgEntry.FindFirst() then
            Error('There is no Ledger Entry with Document No. %1', DocumentNo_iCod);

        Clear(Vendor);
        Vendor.Get(VendLedgEntry."Vendor No.");

        //XMLParameter := Report.RunRequestPage(411);
        Clear(CompanyInfo);
        CompanyInfo.Get();


        Recepients.Add(UserID);
        //SMTPMail.CreateMessage('Intech Systems Pvt. Ltd.', SMTPMailsetup."User ID", Recepients, 'D365 Business Central', '');

        Clear(CompanyInfo);
        CompanyInfo.Get();
        CompanyInfo.CalcFields(Picture);
        VendLedgEntry.CalcFields(Amount);

        BodyHTML_lTxt += '<html>';
        BodyHTML_lTxt += '<head>';
        BodyHTML_lTxt += '<meta charset="utf-8">';
        BodyHTML_lTxt += '<title>A simple, clean, and responsive HTML invoice template</title>';

        BodyHTML_lTxt += '<style>';
        BodyHTML_lTxt += '.invoice-box {';
        BodyHTML_lTxt += 'max-width: 800px;';
        BodyHTML_lTxt += 'margin: auto;';
        BodyHTML_lTxt += 'padding: 30px;';
        BodyHTML_lTxt += 'border: 1px solid #eee;';
        BodyHTML_lTxt += 'box-shadow: 0 0 10px rgba(0, 0, 0, .15;';
        BodyHTML_lTxt += 'font-size: 16px;';
        BodyHTML_lTxt += 'line-height: 24px;';
        BodyHTML_lTxt += 'font-family: ''Helvetica Neue'', ''Helvetica'', Helvetica, Arial, sans-serif;';
        BodyHTML_lTxt += 'color: #555;';
        BodyHTML_lTxt += '}';

        BodyHTML_lTxt += '.invoice-box table {';
        BodyHTML_lTxt += 'width: 100%;';
        BodyHTML_lTxt += 'line-height: inherit;';
        BodyHTML_lTxt += 'text-align: left;';
        BodyHTML_lTxt += '}';

        BodyHTML_lTxt += '.invoice-box table td {';
        BodyHTML_lTxt += 'padding: 5px;';
        BodyHTML_lTxt += 'vertical-align: top;';
        BodyHTML_lTxt += '}';

        BodyHTML_lTxt += '.invoice-box table tr td:nth-child(2) {';
        BodyHTML_lTxt += 'text-align: right;';
        BodyHTML_lTxt += '}';

        BodyHTML_lTxt += '.invoice-box table tr.top table td {';
        BodyHTML_lTxt += 'padding-bottom: 20px;';
        BodyHTML_lTxt += '}';

        BodyHTML_lTxt += '.invoice-box table tr.top table td.title {';
        BodyHTML_lTxt += 'font-size: 45px;';
        BodyHTML_lTxt += 'line-height: 45px;';
        BodyHTML_lTxt += 'color: #333;';
        BodyHTML_lTxt += '}';

        BodyHTML_lTxt += '.invoice-box table tr.information table td {';
        BodyHTML_lTxt += 'padding-bottom: 40px;';
        BodyHTML_lTxt += '}';

        BodyHTML_lTxt += '.invoice-box table tr.heading td {';
        BodyHTML_lTxt += 'background: #eee;';
        BodyHTML_lTxt += 'border-bottom: 1px solid #ddd;';
        BodyHTML_lTxt += 'font-weight: bold;';
        BodyHTML_lTxt += '}';

        BodyHTML_lTxt += '.invoice-box table tr.details td {';
        BodyHTML_lTxt += 'padding-bottom: 20px;';
        BodyHTML_lTxt += '}';

        BodyHTML_lTxt += '.invoice-box table tr.item td{';
        BodyHTML_lTxt += 'border-bottom: 1px solid #eee;';
        BodyHTML_lTxt += '}';

        BodyHTML_lTxt += '.invoice-box table tr.item.last td {';
        BodyHTML_lTxt += 'border-bottom: none;';
        BodyHTML_lTxt += '}';

        BodyHTML_lTxt += '.invoice-box table tr.total td:nth-child(2) {';
        BodyHTML_lTxt += 'border-top: 2px solid #eee;';
        BodyHTML_lTxt += 'font-weight: bold;';
        BodyHTML_lTxt += '}';

        BodyHTML_lTxt += '@media only screen and (max-width: 600px) {';
        BodyHTML_lTxt += '.invoice-box table tr.top table td {';
        BodyHTML_lTxt += 'width: 100%;';
        BodyHTML_lTxt += 'display: block;';
        BodyHTML_lTxt += 'text-align: center;';
        BodyHTML_lTxt += '}';

        BodyHTML_lTxt += '.invoice-box table tr.information table td {';
        BodyHTML_lTxt += 'width: 100%;';
        BodyHTML_lTxt += 'display: block;';
        BodyHTML_lTxt += 'text-align: center;';
        BodyHTML_lTxt += '}';
        BodyHTML_lTxt += '}';

        BodyHTML_lTxt += '/** RTL **/';
        BodyHTML_lTxt += '.rtl {';
        BodyHTML_lTxt += 'direction: rtl;';
        BodyHTML_lTxt += 'font-family: Tahoma, ''Helvetica Neue'', ''Helvetica'', Helvetica, Arial, sans-serif;';
        BodyHTML_lTxt += '}';

        BodyHTML_lTxt += '.rtl table {';
        BodyHTML_lTxt += 'text-align: right;';
        BodyHTML_lTxt += '}';

        BodyHTML_lTxt += '.rtl table tr td:nth-child(2) {';
        BodyHTML_lTxt += 'text-align: left;';
        BodyHTML_lTxt += '}';
        BodyHTML_lTxt += '</style>';
        BodyHTML_lTxt += '</head>';

        BodyHTML_lTxt += '<body>';
        BodyHTML_lTxt += '<div class="invoice-box">';
        BodyHTML_lTxt += '<table cellpadding="0" cellspacing="0">';
        BodyHTML_lTxt += '<tr class="top">';
        BodyHTML_lTxt += '<td colspan="2">';
        BodyHTML_lTxt += '<table>';
        BodyHTML_lTxt += '<tr>';
        BodyHTML_lTxt += '<td>';
        BodyHTML_lTxt += '<img src="https://106c4.wpc.azureedge.net/80106C4/Gallery-Prod/cdn/2015-02-24/prod20161101-microsoft-windowsazure-gallery/microsoftdynsmb.3a67602d-0a4f-4ae4-ad03-c1124f6ac3cf.1.0.2/Icon/large.png" height="100" width="100">';
        BodyHTML_lTxt += '</td>';

        BodyHTML_lTxt += '<td class="title">';
        BodyHTML_lTxt += '<b><font size = "5">Vendor Payments</font></b><br>';
        BodyHTML_lTxt += '</td>';
        BodyHTML_lTxt += '</tr>';
        BodyHTML_lTxt += '</table>';
        BodyHTML_lTxt += '</td>';
        BodyHTML_lTxt += '</tr>';

        BodyHTML_lTxt += '<tr class="information">';
        BodyHTML_lTxt += '<td colspan="2">';
        BodyHTML_lTxt += '<table>';
        BodyHTML_lTxt += '<tr>';
        BodyHTML_lTxt += '<td>';
        BodyHTML_lTxt += CompanyInfo.Name + '<br>';
        BodyHTML_lTxt += CompanyInfo.Address + '<br>';
        BodyHTML_lTxt += CompanyInfo."Address 2" + '<br>';
        BodyHTML_lTxt += CompanyInfo.City + '<br>';
        BodyHTML_lTxt += CompanyInfo."Post Code" + '<br>';
        BodyHTML_lTxt += CompanyInfo."Phone No." + '<br>';
        BodyHTML_lTxt += '</td>';

        BodyHTML_lTxt += '<td>';
        BodyHTML_lTxt += CompanyInfo."Contact Person" + '<br>';
        BodyHTML_lTxt += CompanyInfo."E-Mail" + '<br>';
        BodyHTML_lTxt += 'Created Date:' + Format(CurrentDateTime()) + '<br>';
        BodyHTML_lTxt += '</td>';
        BodyHTML_lTxt += '</tr>';
        BodyHTML_lTxt += '</table>';
        BodyHTML_lTxt += '</td>';
        BodyHTML_lTxt += '</tr>';

        BodyHTML_lTxt += '<tr class="heading">';
        BodyHTML_lTxt += '<td>';
        BodyHTML_lTxt += 'Account No.';
        BodyHTML_lTxt += '</td>';

        BodyHTML_lTxt += '<td>';
        BodyHTML_lTxt += Vendor."No.";
        BodyHTML_lTxt += '</td>';
        BodyHTML_lTxt += '</tr>';

        BodyHTML_lTxt += '<tr class="details">';
        BodyHTML_lTxt += '<td>';
        BodyHTML_lTxt += 'Name';
        BodyHTML_lTxt += '</td>';

        BodyHTML_lTxt += '<td>';
        BodyHTML_lTxt += Vendor.Name;
        BodyHTML_lTxt += '</td>';
        BodyHTML_lTxt += '</tr>';

        BodyHTML_lTxt += '<tr class="heading">';
        BodyHTML_lTxt += '<td>';
        BodyHTML_lTxt += 'Details:';
        BodyHTML_lTxt += '</td>';

        BodyHTML_lTxt += '<td>';
        BodyHTML_lTxt += '';
        BodyHTML_lTxt += '</td>';
        BodyHTML_lTxt += '</tr>';

        BodyHTML_lTxt += '<tr class="item">';
        BodyHTML_lTxt += '<td>';
        BodyHTML_lTxt += 'Document No.';
        BodyHTML_lTxt += '</td>';

        BodyHTML_lTxt += '<td>';
        BodyHTML_lTxt += DocumentNo_iCod;
        BodyHTML_lTxt += '</td>';
        BodyHTML_lTxt += '</tr>';

        BodyHTML_lTxt += '<tr class="item">';
        BodyHTML_lTxt += '<td>';
        BodyHTML_lTxt += 'Order Date';
        BodyHTML_lTxt += '</td>';

        BodyHTML_lTxt += '<td>';
        BodyHTML_lTxt += Format(VendLedgEntry."Posting Date");
        BodyHTML_lTxt += '</td>';
        BodyHTML_lTxt += '</tr>';

        BodyHTML_lTxt += '<tr class="item last">';
        BodyHTML_lTxt += '<td>';
        BodyHTML_lTxt += '';
        BodyHTML_lTxt += '</td>';

        BodyHTML_lTxt += '<td>';
        BodyHTML_lTxt += '</td>';
        BodyHTML_lTxt += '</tr>';

        BodyHTML_lTxt += '<tr class="heading">';
        BodyHTML_lTxt += '<td>';
        BodyHTML_lTxt += 'Total';
        BodyHTML_lTxt += '</td>';

        BodyHTML_lTxt += '<td>';
        BodyHTML_lTxt += Format(VendLedgEntry.Amount);
        BodyHTML_lTxt += '</td>';
        BodyHTML_lTxt += '</tr>';

        BodyHTML_lTxt += '</table>';
        BodyHTML_lTxt += '</div>';
        BodyHTML_lTxt += '</body>';
        BodyHTML_lTxt += '</html>';
        BodyHTML_lTxt += '<br><br>Kindly go through attached Document for more details.';
        BodyHTML_lTxt += '<br><br>Regards,<br><b>';
        BodyHTML_lTxt += CompanyInfo."Contact Person" + '<br>';
        BodyHTML_lTxt += CompanyInfo.Name + '<br>';
        BodyHTML_lTxt += CompanyInfo.Address + '<br>';
        BodyHTML_lTxt += CompanyInfo."Address 2" + '<br>';
        BodyHTML_lTxt += CompanyInfo.City + ',';
        BodyHTML_lTxt += CompanyInfo."Post Code" + '<br>';
        BodyHTML_lTxt += CompanyInfo."Phone No." + '<br>';
        BodyHTML_lTxt += CompanyInfo."E-Mail" + '<br></b>';

        WebPortalSetup_gRec.Get();
        if WebPortalSetup_gRec."Email as CC for Cust/Vend" then begin
            Clear(Recepients);
            Recepients.Add(Vendor."E-Mail");
            CC.Add(Vendor."E-Mail");
        end;

        EmailMessage.Create(Recepients, 'D365 Business Central', BodyHTML_lTxt, true, CC, BCC);
        XMLParameter := '<?xml version="1.0" standalone="yes"?><ReportParameters name="Vendor - Payment Receipt" id="411"><DataItems><DataItem name="Vendor Ledger Entry">VERSION(1) SORTING(Field5,Field3,Field4,Field11) WHERE(Field6=1(' + VendLedgEntry."Document No." + '))</DataItem><DataItem name="PageLoop">VERSION(1) SORTING(Field1)</DataItem><DataItem name="DetailedVendorLedgEntry1">VERSION(1) SORTING(Field36,Field3)</DataItem><DataItem name="VendLedgEntry1">VERSION(1) SORTING(Field1)</DataItem><DataItem name="DetailedVendorLedgEntry2">VERSION(1) SORTING(Field2,Field3,Field4)</DataItem><DataItem name="VendLedgEntry2">VERSION(1) SORTING(Field1)</DataItem><DataItem name="Total">VERSION(1) SORTING(Field1)</DataItem></DataItems></ReportParameters>';

        TempBlob.CreateOutStream(EmailoutStream);
        Report.SaveAs(411, XMLParameter, ReportFormat::Pdf, EmailoutStream);
        TempBlob.CreateInStream(EmailInStream);
        EmailMessage.AddAttachment('VendorPaymentReceipt' + DocumentNo_iCod + '.pdf', 'PDF', EmailInStream);

        // if SMTPMail.TrySend() then begin
        //     Message('Email Sent Successfully');
        //     exit(true);
        // end;
        Clear(Email);
        if Email.Send(EmailMessage, Enum::"Email Scenario"::Default) then begin
            if GuiAllowed then
                Message('Email Sent Successfully');
            exit(true);
        end;
    end;

    procedure PrintPendingSalesInvoice_gFnc(No_iCod: Code[20]; UserID: Code[80]): Boolean
    var
        CompanyInfo: Record "Company Information";
        Customer: Record Customer;
        SalesHeader_lRec: Record "Sales Header";
        Email: Codeunit Email;
        EmailMessage: Codeunit "Email Message";
        TempBlob: Codeunit "Temp Blob";
        EmailInStream: InStream;
        BCC: List of [Text];
        CC: List of [Text];
        Recepients: List of [Text];
        EmailoutStream: OutStream;
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

        Recepients.Add(UserID);
        //SMTPMail.CreateMessage('Intech Systems Pvt. Ltd.', SMTPMailsetup."User ID", Recepients, 'D365 Business Central', '');

        Clear(CompanyInfo);
        CompanyInfo.Get();
        CompanyInfo.CalcFields(Picture);
        SalesHeader_lRec.CalcFields("Amount Including VAT");

        BodyHTML_lTxt += '<html>';
        BodyHTML_lTxt += '<head>';
        BodyHTML_lTxt += '<meta charset="utf-8">';
        BodyHTML_lTxt += '<title>A simple, clean, and responsive HTML invoice template</title>';

        BodyHTML_lTxt += '<style>';
        BodyHTML_lTxt += '.invoice-box {';
        BodyHTML_lTxt += 'max-width: 800px;';
        BodyHTML_lTxt += 'margin: auto;';
        BodyHTML_lTxt += 'padding: 30px;';
        BodyHTML_lTxt += 'border: 1px solid #eee;';
        BodyHTML_lTxt += 'box-shadow: 0 0 10px rgba(0, 0, 0, .15;';
        BodyHTML_lTxt += 'font-size: 16px;';
        BodyHTML_lTxt += 'line-height: 24px;';
        BodyHTML_lTxt += 'font-family: ''Helvetica Neue'', ''Helvetica'', Helvetica, Arial, sans-serif;';
        BodyHTML_lTxt += 'color: #555;';
        BodyHTML_lTxt += '}';

        BodyHTML_lTxt += '.invoice-box table {';
        BodyHTML_lTxt += 'width: 100%;';
        BodyHTML_lTxt += 'line-height: inherit;';
        BodyHTML_lTxt += 'text-align: left;';
        BodyHTML_lTxt += '}';

        BodyHTML_lTxt += '.invoice-box table td {';
        BodyHTML_lTxt += 'padding: 5px;';
        BodyHTML_lTxt += 'vertical-align: top;';
        BodyHTML_lTxt += '}';

        BodyHTML_lTxt += '.invoice-box table tr td:nth-child(2) {';
        BodyHTML_lTxt += 'text-align: right;';
        BodyHTML_lTxt += '}';

        BodyHTML_lTxt += '.invoice-box table tr.top table td {';
        BodyHTML_lTxt += 'padding-bottom: 20px;';
        BodyHTML_lTxt += '}';

        BodyHTML_lTxt += '.invoice-box table tr.top table td.title {';
        BodyHTML_lTxt += 'font-size: 45px;';
        BodyHTML_lTxt += 'line-height: 45px;';
        BodyHTML_lTxt += 'color: #333;';
        BodyHTML_lTxt += '}';

        BodyHTML_lTxt += '.invoice-box table tr.information table td {';
        BodyHTML_lTxt += 'padding-bottom: 40px;';
        BodyHTML_lTxt += '}';

        BodyHTML_lTxt += '.invoice-box table tr.heading td {';
        BodyHTML_lTxt += 'background: #eee;';
        BodyHTML_lTxt += 'border-bottom: 1px solid #ddd;';
        BodyHTML_lTxt += 'font-weight: bold;';
        BodyHTML_lTxt += '}';

        BodyHTML_lTxt += '.invoice-box table tr.details td {';
        BodyHTML_lTxt += 'padding-bottom: 20px;';
        BodyHTML_lTxt += '}';

        BodyHTML_lTxt += '.invoice-box table tr.item td{';
        BodyHTML_lTxt += 'border-bottom: 1px solid #eee;';
        BodyHTML_lTxt += '}';

        BodyHTML_lTxt += '.invoice-box table tr.item.last td {';
        BodyHTML_lTxt += 'border-bottom: none;';
        BodyHTML_lTxt += '}';

        BodyHTML_lTxt += '.invoice-box table tr.total td:nth-child(2) {';
        BodyHTML_lTxt += 'border-top: 2px solid #eee;';
        BodyHTML_lTxt += 'font-weight: bold;';
        BodyHTML_lTxt += '}';

        BodyHTML_lTxt += '@media only screen and (max-width: 600px) {';
        BodyHTML_lTxt += '.invoice-box table tr.top table td {';
        BodyHTML_lTxt += 'width: 100%;';
        BodyHTML_lTxt += 'display: block;';
        BodyHTML_lTxt += 'text-align: center;';
        BodyHTML_lTxt += '}';

        BodyHTML_lTxt += '.invoice-box table tr.information table td {';
        BodyHTML_lTxt += 'width: 100%;';
        BodyHTML_lTxt += 'display: block;';
        BodyHTML_lTxt += 'text-align: center;';
        BodyHTML_lTxt += '}';
        BodyHTML_lTxt += '}';

        BodyHTML_lTxt += '/** RTL **/';
        BodyHTML_lTxt += '.rtl {';
        BodyHTML_lTxt += 'direction: rtl;';
        BodyHTML_lTxt += 'font-family: Tahoma, ''Helvetica Neue'', ''Helvetica'', Helvetica, Arial, sans-serif;';
        BodyHTML_lTxt += '}';

        BodyHTML_lTxt += '.rtl table {';
        BodyHTML_lTxt += 'text-align: right;';
        BodyHTML_lTxt += '}';

        BodyHTML_lTxt += '.rtl table tr td:nth-child(2) {';
        BodyHTML_lTxt += 'text-align: left;';
        BodyHTML_lTxt += '}';
        BodyHTML_lTxt += '</style>';
        BodyHTML_lTxt += '</head>';

        BodyHTML_lTxt += '<body>';
        BodyHTML_lTxt += '<div class="invoice-box">';
        BodyHTML_lTxt += '<table cellpadding="0" cellspacing="0">';
        BodyHTML_lTxt += '<tr class="top">';
        BodyHTML_lTxt += '<td colspan="2">';
        BodyHTML_lTxt += '<table>';
        BodyHTML_lTxt += '<tr>';
        BodyHTML_lTxt += '<td>';
        BodyHTML_lTxt += '<img src="https://106c4.wpc.azureedge.net/80106C4/Gallery-Prod/cdn/2015-02-24/prod20161101-microsoft-windowsazure-gallery/microsoftdynsmb.3a67602d-0a4f-4ae4-ad03-c1124f6ac3cf.1.0.2/Icon/large.png" height="100" width="100">';
        BodyHTML_lTxt += '</td>';

        BodyHTML_lTxt += '<td class="title">';
        BodyHTML_lTxt += '<b><font size = "5">Pending Sales Invoice</font></b><br>';
        BodyHTML_lTxt += '</td>';
        BodyHTML_lTxt += '</tr>';
        BodyHTML_lTxt += '</table>';
        BodyHTML_lTxt += '</td>';
        BodyHTML_lTxt += '</tr>';

        BodyHTML_lTxt += '<tr class="information">';
        BodyHTML_lTxt += '<td colspan="2">';
        BodyHTML_lTxt += '<table>';
        BodyHTML_lTxt += '<tr>';
        BodyHTML_lTxt += '<td>';
        BodyHTML_lTxt += CompanyInfo.Name + '<br>';
        BodyHTML_lTxt += CompanyInfo.Address + '<br>';
        BodyHTML_lTxt += CompanyInfo."Address 2" + '<br>';
        BodyHTML_lTxt += CompanyInfo.City + '<br>';
        BodyHTML_lTxt += CompanyInfo."Post Code" + '<br>';
        BodyHTML_lTxt += CompanyInfo."Phone No." + '<br>';
        BodyHTML_lTxt += '</td>';

        BodyHTML_lTxt += '<td>';
        BodyHTML_lTxt += CompanyInfo."Contact Person" + '<br>';
        BodyHTML_lTxt += CompanyInfo."E-Mail" + '<br>';
        BodyHTML_lTxt += 'Created Date:' + Format(CurrentDateTime()) + '<br>';
        BodyHTML_lTxt += '</td>';
        BodyHTML_lTxt += '</tr>';
        BodyHTML_lTxt += '</table>';
        BodyHTML_lTxt += '</td>';
        BodyHTML_lTxt += '</tr>';

        BodyHTML_lTxt += '<tr class="heading">';
        BodyHTML_lTxt += '<td>';
        BodyHTML_lTxt += 'Account No.';
        BodyHTML_lTxt += '</td>';

        BodyHTML_lTxt += '<td>';
        BodyHTML_lTxt += Customer."No.";
        BodyHTML_lTxt += '</td>';
        BodyHTML_lTxt += '</tr>';

        BodyHTML_lTxt += '<tr class="details">';
        BodyHTML_lTxt += '<td>';
        BodyHTML_lTxt += 'Name';
        BodyHTML_lTxt += '</td>';

        BodyHTML_lTxt += '<td>';
        BodyHTML_lTxt += Customer.Name;
        BodyHTML_lTxt += '</td>';
        BodyHTML_lTxt += '</tr>';

        BodyHTML_lTxt += '<tr class="heading">';
        BodyHTML_lTxt += '<td>';
        BodyHTML_lTxt += 'Details:';
        BodyHTML_lTxt += '</td>';

        BodyHTML_lTxt += '<td>';
        BodyHTML_lTxt += '';
        BodyHTML_lTxt += '</td>';
        BodyHTML_lTxt += '</tr>';

        BodyHTML_lTxt += '<tr class="item">';
        BodyHTML_lTxt += '<td>';
        BodyHTML_lTxt += 'Document No.';
        BodyHTML_lTxt += '</td>';

        BodyHTML_lTxt += '<td>';
        BodyHTML_lTxt += No_iCod;
        BodyHTML_lTxt += '</td>';
        BodyHTML_lTxt += '</tr>';

        BodyHTML_lTxt += '<tr class="item">';
        BodyHTML_lTxt += '<td>';
        BodyHTML_lTxt += 'Order Date';
        BodyHTML_lTxt += '</td>';

        BodyHTML_lTxt += '<td>';
        BodyHTML_lTxt += Format(SalesHeader_lRec."Order Date");
        BodyHTML_lTxt += '</td>';
        BodyHTML_lTxt += '</tr>';

        BodyHTML_lTxt += '<tr class="item last">';
        BodyHTML_lTxt += '<td>';
        BodyHTML_lTxt += '';
        BodyHTML_lTxt += '</td>';

        BodyHTML_lTxt += '<td>';
        BodyHTML_lTxt += '</td>';
        BodyHTML_lTxt += '</tr>';

        BodyHTML_lTxt += '<tr class="heading">';
        BodyHTML_lTxt += '<td>';
        BodyHTML_lTxt += 'Total';
        BodyHTML_lTxt += '</td>';

        BodyHTML_lTxt += '<td>';
        BodyHTML_lTxt += Format(SalesHeader_lRec."Amount Including VAT");
        BodyHTML_lTxt += '</td>';
        BodyHTML_lTxt += '</tr>';

        BodyHTML_lTxt += '</table>';
        BodyHTML_lTxt += '</div>';
        BodyHTML_lTxt += '</body>';
        BodyHTML_lTxt += '</html>';
        BodyHTML_lTxt += '<br><br>Kindly go through attached Document for more details.';
        BodyHTML_lTxt += '<br><br>Regards,<br><b>';
        BodyHTML_lTxt += CompanyInfo."Contact Person" + '<br>';
        BodyHTML_lTxt += CompanyInfo.Name + '<br>';
        BodyHTML_lTxt += CompanyInfo.Address + '<br>';
        BodyHTML_lTxt += CompanyInfo."Address 2" + '<br>';
        BodyHTML_lTxt += CompanyInfo.City + ',';
        BodyHTML_lTxt += CompanyInfo."Post Code" + '<br>';
        BodyHTML_lTxt += CompanyInfo."Phone No." + '<br>';
        BodyHTML_lTxt += CompanyInfo."E-Mail" + '<br></b>';

        WebPortalSetup_gRec.Get();
        if WebPortalSetup_gRec."Email as CC for Cust/Vend" then begin
            Clear(Recepients);
            Recepients.Add(Customer."E-Mail");
            CC.Add(Customer."E-Mail");
        end;
        EmailMessage.Create(Recepients, 'D365 Business Central', BodyHTML_lTxt, true, CC, BCC);

        XMLParameter := '<?xml version="1.0" standalone="yes"?><ReportParameters name="Sales Document - Test" id="202"><Options><Field name="ShipReceiveOnNextPostReq">true</Field><Field name="InvOnNextPostReq">true</Field><Field name="ShowDim">false</Field><Field name="ShowCostAssignment">false</Field><Field name="Summarize">false</Field></Options><DataItems><DataItem name="Sales Header">VERSION(1) SORTING(Field1,Field3) WHERE(Field1=1(2),Field3=1(' + SalesHeader_lRec."No." + '))</DataItem><DataItem name="PageCounter">VERSION(1) SORTING(Field1)</DataItem><DataItem name="DimensionLoop1">VERSION(1) SORTING(Field1)</DataItem><DataItem name="HeaderErrorCounter">VERSION(1) SORTING(Field1)</DataItem><DataItem name="CopyLoop">VERSION(1) SORTING(Field1)</DataItem><DataItem name="Sales Line">VERSION(1) SORTING(Field1,Field3,Field4)</DataItem><DataItem name="RoundLoop">VERSION(1) SORTING(Field1)</DataItem><DataItem name="DimensionLoop2">VERSION(1) SORTING(Field1)</DataItem><DataItem name="LineErrorCounter">VERSION(1) SORTING(Field1)</DataItem><DataItem name="VATCounter">VERSION(1) SORTING(Field1)</DataItem><DataItem name="SalesTaxCounter">VERSION(1) SORTING(Field1)</DataItem><DataItem name="Item Charge Assignment (Sales)">VERSION(1) SORTING(Field1,Field2,Field3,Field4)</DataItem></DataItems></ReportParameters>';

        TempBlob.CreateOutStream(EmailoutStream);
        Report.SaveAs(202, XMLParameter, ReportFormat::Pdf, EmailoutStream);
        TempBlob.CreateInStream(EmailInStream);
        EmailMessage.AddAttachment('SalesInvoice' + No_iCod + '.pdf', 'PDF', EmailInStream);

        // if SMTPMail.TrySend() then begin
        //     Message('Email Sent Successfully');
        //     exit(true);
        // end;
        Clear(Email);
        if Email.Send(EmailMessage, Enum::"Email Scenario"::Default) then begin
            if GuiAllowed then
                Message('Email Sent Successfully');
            exit(true);
        end;
    end;

    procedure PrintPostedPurchInvoice_gFnc(DocumentNo_iCod: Code[20]; UserID: Code[80]): Boolean
    var
        CompanyInfo: Record "Company Information";
        PurchInvHeader_lRec: Record "Purch. Inv. Header";
        Vendor: Record Vendor;
        Email: Codeunit Email;
        EmailMessage: Codeunit "Email Message";
        TempBlob: Codeunit "Temp Blob";
        EmailInStream: InStream;
        BCC: List of [Text];

        CC: List of [Text];
        Recepients: List of [Text];
        EmailoutStream: OutStream;
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

        BodyHTML_lTxt += '<html>';
        BodyHTML_lTxt += '<head>';
        BodyHTML_lTxt += '<meta charset="utf-8">';
        BodyHTML_lTxt += '<title>A simple, clean, and responsive HTML invoice template</title>';

        BodyHTML_lTxt += '<style>';
        BodyHTML_lTxt += '.invoice-box {';
        BodyHTML_lTxt += 'max-width: 800px;';
        BodyHTML_lTxt += 'margin: auto;';
        BodyHTML_lTxt += 'padding: 30px;';
        BodyHTML_lTxt += 'border: 1px solid #eee;';
        BodyHTML_lTxt += 'box-shadow: 0 0 10px rgba(0, 0, 0, .15;';
        BodyHTML_lTxt += 'font-size: 16px;';
        BodyHTML_lTxt += 'line-height: 24px;';
        BodyHTML_lTxt += 'font-family: ''Helvetica Neue'', ''Helvetica'', Helvetica, Arial, sans-serif;';
        BodyHTML_lTxt += 'color: #555;';
        BodyHTML_lTxt += '}';

        BodyHTML_lTxt += '.invoice-box table {';
        BodyHTML_lTxt += 'width: 100%;';
        BodyHTML_lTxt += 'line-height: inherit;';
        BodyHTML_lTxt += 'text-align: left;';
        BodyHTML_lTxt += '}';

        BodyHTML_lTxt += '.invoice-box table td {';
        BodyHTML_lTxt += 'padding: 5px;';
        BodyHTML_lTxt += 'vertical-align: top;';
        BodyHTML_lTxt += '}';

        BodyHTML_lTxt += '.invoice-box table tr td:nth-child(2) {';
        BodyHTML_lTxt += 'text-align: right;';
        BodyHTML_lTxt += '}';

        BodyHTML_lTxt += '.invoice-box table tr.top table td {';
        BodyHTML_lTxt += 'padding-bottom: 20px;';
        BodyHTML_lTxt += '}';

        BodyHTML_lTxt += '.invoice-box table tr.top table td.title {';
        BodyHTML_lTxt += 'font-size: 45px;';
        BodyHTML_lTxt += 'line-height: 45px;';
        BodyHTML_lTxt += 'color: #333;';
        BodyHTML_lTxt += '}';

        BodyHTML_lTxt += '.invoice-box table tr.information table td {';
        BodyHTML_lTxt += 'padding-bottom: 40px;';
        BodyHTML_lTxt += '}';

        BodyHTML_lTxt += '.invoice-box table tr.heading td {';
        BodyHTML_lTxt += 'background: #eee;';
        BodyHTML_lTxt += 'border-bottom: 1px solid #ddd;';
        BodyHTML_lTxt += 'font-weight: bold;';
        BodyHTML_lTxt += '}';

        BodyHTML_lTxt += '.invoice-box table tr.details td {';
        BodyHTML_lTxt += 'padding-bottom: 20px;';
        BodyHTML_lTxt += '}';

        BodyHTML_lTxt += '.invoice-box table tr.item td{';
        BodyHTML_lTxt += 'border-bottom: 1px solid #eee;';
        BodyHTML_lTxt += '}';

        BodyHTML_lTxt += '.invoice-box table tr.item.last td {';
        BodyHTML_lTxt += 'border-bottom: none;';
        BodyHTML_lTxt += '}';

        BodyHTML_lTxt += '.invoice-box table tr.total td:nth-child(2) {';
        BodyHTML_lTxt += 'border-top: 2px solid #eee;';
        BodyHTML_lTxt += 'font-weight: bold;';
        BodyHTML_lTxt += '}';

        BodyHTML_lTxt += '@media only screen and (max-width: 600px) {';
        BodyHTML_lTxt += '.invoice-box table tr.top table td {';
        BodyHTML_lTxt += 'width: 100%;';
        BodyHTML_lTxt += 'display: block;';
        BodyHTML_lTxt += 'text-align: center;';
        BodyHTML_lTxt += '}';

        BodyHTML_lTxt += '.invoice-box table tr.information table td {';
        BodyHTML_lTxt += 'width: 100%;';
        BodyHTML_lTxt += 'display: block;';
        BodyHTML_lTxt += 'text-align: center;';
        BodyHTML_lTxt += '}';
        BodyHTML_lTxt += '}';

        BodyHTML_lTxt += '/** RTL **/';
        BodyHTML_lTxt += '.rtl {';
        BodyHTML_lTxt += 'direction: rtl;';
        BodyHTML_lTxt += 'font-family: Tahoma, ''Helvetica Neue'', ''Helvetica'', Helvetica, Arial, sans-serif;';
        BodyHTML_lTxt += '}';

        BodyHTML_lTxt += '.rtl table {';
        BodyHTML_lTxt += 'text-align: right;';
        BodyHTML_lTxt += '}';

        BodyHTML_lTxt += '.rtl table tr td:nth-child(2) {';
        BodyHTML_lTxt += 'text-align: left;';
        BodyHTML_lTxt += '}';
        BodyHTML_lTxt += '</style>';
        BodyHTML_lTxt += '</head>';

        BodyHTML_lTxt += '<body>';
        BodyHTML_lTxt += '<div class="invoice-box">';
        BodyHTML_lTxt += '<table cellpadding="0" cellspacing="0">';
        BodyHTML_lTxt += '<tr class="top">';
        BodyHTML_lTxt += '<td colspan="2">';
        BodyHTML_lTxt += '<table>';
        BodyHTML_lTxt += '<tr>';
        BodyHTML_lTxt += '<td>';
        BodyHTML_lTxt += '<img src="https://106c4.wpc.azureedge.net/80106C4/Gallery-Prod/cdn/2015-02-24/prod20161101-microsoft-windowsazure-gallery/microsoftdynsmb.3a67602d-0a4f-4ae4-ad03-c1124f6ac3cf.1.0.2/Icon/large.png" height="100" width="100">';
        BodyHTML_lTxt += '</td>';

        BodyHTML_lTxt += '<td class="title">';
        BodyHTML_lTxt += '<b><font size = "5">Purchase Invoice</font></b><br>';
        BodyHTML_lTxt += '</td>';
        BodyHTML_lTxt += '</tr>';
        BodyHTML_lTxt += '</table>';
        BodyHTML_lTxt += '</td>';
        BodyHTML_lTxt += '</tr>';

        BodyHTML_lTxt += '<tr class="information">';
        BodyHTML_lTxt += '<td colspan="2">';
        BodyHTML_lTxt += '<table>';
        BodyHTML_lTxt += '<tr>';
        BodyHTML_lTxt += '<td>';
        BodyHTML_lTxt += CompanyInfo.Name + '<br>';
        BodyHTML_lTxt += CompanyInfo.Address + '<br>';
        BodyHTML_lTxt += CompanyInfo."Address 2" + '<br>';
        BodyHTML_lTxt += CompanyInfo.City + '<br>';
        BodyHTML_lTxt += CompanyInfo."Post Code" + '<br>';
        BodyHTML_lTxt += CompanyInfo."Phone No." + '<br>';
        BodyHTML_lTxt += '</td>';

        BodyHTML_lTxt += '<td>';
        BodyHTML_lTxt += CompanyInfo."Contact Person" + '<br>';
        BodyHTML_lTxt += CompanyInfo."E-Mail" + '<br>';
        BodyHTML_lTxt += 'Created Date:' + Format(CurrentDateTime()) + '<br>';
        BodyHTML_lTxt += '</td>';
        BodyHTML_lTxt += '</tr>';
        BodyHTML_lTxt += '</table>';
        BodyHTML_lTxt += '</td>';
        BodyHTML_lTxt += '</tr>';

        BodyHTML_lTxt += '<tr class="heading">';
        BodyHTML_lTxt += '<td>';
        BodyHTML_lTxt += 'Account No.';
        BodyHTML_lTxt += '</td>';

        BodyHTML_lTxt += '<td>';
        BodyHTML_lTxt += Vendor."No.";
        BodyHTML_lTxt += '</td>';
        BodyHTML_lTxt += '</tr>';

        BodyHTML_lTxt += '<tr class="details">';
        BodyHTML_lTxt += '<td>';
        BodyHTML_lTxt += 'Name';
        BodyHTML_lTxt += '</td>';

        BodyHTML_lTxt += '<td>';
        BodyHTML_lTxt += Vendor.Name;
        BodyHTML_lTxt += '</td>';
        BodyHTML_lTxt += '</tr>';

        BodyHTML_lTxt += '<tr class="heading">';
        BodyHTML_lTxt += '<td>';
        BodyHTML_lTxt += 'Details:';
        BodyHTML_lTxt += '</td>';

        BodyHTML_lTxt += '<td>';
        BodyHTML_lTxt += '';
        BodyHTML_lTxt += '</td>';
        BodyHTML_lTxt += '</tr>';

        BodyHTML_lTxt += '<tr class="item">';
        BodyHTML_lTxt += '<td>';
        BodyHTML_lTxt += 'Document No.';
        BodyHTML_lTxt += '</td>';

        BodyHTML_lTxt += '<td>';
        BodyHTML_lTxt += DocumentNo_iCod;
        BodyHTML_lTxt += '</td>';
        BodyHTML_lTxt += '</tr>';

        BodyHTML_lTxt += '<tr class="item">';
        BodyHTML_lTxt += '<td>';
        BodyHTML_lTxt += 'Order Date';
        BodyHTML_lTxt += '</td>';

        BodyHTML_lTxt += '<td>';
        BodyHTML_lTxt += Format(PurchInvHeader_lRec."Order Date");
        BodyHTML_lTxt += '</td>';
        BodyHTML_lTxt += '</tr>';

        BodyHTML_lTxt += '<tr class="item last">';
        BodyHTML_lTxt += '<td>';
        BodyHTML_lTxt += '';
        BodyHTML_lTxt += '</td>';

        BodyHTML_lTxt += '<td>';
        BodyHTML_lTxt += '</td>';
        BodyHTML_lTxt += '</tr>';

        BodyHTML_lTxt += '<tr class="heading">';
        BodyHTML_lTxt += '<td>';
        BodyHTML_lTxt += 'Total';
        BodyHTML_lTxt += '</td>';

        BodyHTML_lTxt += '<td>';
        BodyHTML_lTxt += Format(PurchInvHeader_lRec."Amount Including VAT");
        BodyHTML_lTxt += '</td>';
        BodyHTML_lTxt += '</tr>';

        BodyHTML_lTxt += '</table>';
        BodyHTML_lTxt += '</div>';
        BodyHTML_lTxt += '</body>';
        BodyHTML_lTxt += '</html>';
        BodyHTML_lTxt += '<br><br>Kindly go through attached Document for more details.';
        BodyHTML_lTxt += '<br><br>Regards,<br><b>';
        BodyHTML_lTxt += CompanyInfo."Contact Person" + '<br>';
        BodyHTML_lTxt += CompanyInfo.Name + '<br>';
        BodyHTML_lTxt += CompanyInfo.Address + '<br>';
        BodyHTML_lTxt += CompanyInfo."Address 2" + '<br>';
        BodyHTML_lTxt += CompanyInfo.City + ',';
        BodyHTML_lTxt += CompanyInfo."Post Code" + '<br>';
        BodyHTML_lTxt += CompanyInfo."Phone No." + '<br>';
        BodyHTML_lTxt += CompanyInfo."E-Mail" + '<br></b>';

        WebPortalSetup_gRec.Get();
        if WebPortalSetup_gRec."Email as CC for Cust/Vend" then begin
            Clear(Recepients);
            Recepients.Add(Vendor."E-Mail");
            CC.Add(Vendor."E-Mail");
        end;

        EmailMessage.Create(Recepients, 'D365 Business Central', BodyHTML_lTxt, true, CC, BCC);
        XMLParameter := '<?xml version="1.0" standalone="yes"?><ReportParameters name="Purchase - Invoice" id="406"><Options><Field name="NoOfCopies">0</Field><Field name="ShowInternalInfo">false</Field><Field name="LogInteraction">true</Field></Options><DataItems><DataItem name="Purch. Inv. Header">VERSION(1) SORTING(Field3) WHERE(Field3=1(' + PurchInvHeader_lRec."No." + '))</DataItem><DataItem name="CopyLoop">VERSION(1) SORTING(Field1)</DataItem><DataItem name="PageLoop">VERSION(1) SORTING(Field1)</DataItem><DataItem name="DimensionLoop1">VERSION(1) SORTING(Field1)</DataItem><DataItem name="Purch. Inv. Line">VERSION(1) SORTING(Field3,Field4)</DataItem><DataItem name="DimensionLoop2">VERSION(1) SORTING(Field1)</DataItem><DataItem name="VATCounter">VERSION(1) SORTING(Field1)</DataItem><DataItem name="VATCounterLCY">VERSION(1) SORTING(Field1)</DataItem><DataItem name="Total">VERSION(1) SORTING(Field1)</DataItem><DataItem name="Total2">VERSION(1) SORTING(Field1)</DataItem><DataItem name="Total3">VERSION(1) SORTING(Field1)</DataItem></DataItems></ReportParameters>';

        TempBlob.CreateOutStream(EmailoutStream);
        TempBlob.CreateInStream(EmailInStream);

        Report.SaveAs(406, XMLParameter, ReportFormat::Pdf, EmailoutStream);
        EmailMessage.AddAttachment('PostedPurchaseInvoice' + DocumentNo_iCod + '.pdf', 'PDF', EmailInStream);

        // if SMTPMail.TrySend() then begin
        //     Message('Email Sent Successfully');
        //     exit(true);
        // end;
        Clear(Email);
        if Email.Send(EmailMessage, Enum::"Email Scenario"::Default) then begin
            if GuiAllowed then
                Message('Email Sent Successfully');
            exit(true);
        end;
    end;

    procedure PrintPostedPurchRcpt_gFnc(DocumentNo_iCod: Code[20]; UserID: Code[80]): Boolean
    var
        CompanyInfo: Record "Company Information";
        PurchRcptHeader_lRec: Record "Purch. Rcpt. Header";
        Vendor: Record Vendor;
        Email: Codeunit Email;
        EmailMessage: Codeunit "Email Message";
        TempBlob: Codeunit "Temp Blob";
        EmailInStream: InStream;
        BCC: List of [Text];
        CC: List of [Text];
        Recepients: List of [Text];
        EmailoutStream: OutStream;
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

        BodyHTML_lTxt += '<html>';
        BodyHTML_lTxt += '<head>';
        BodyHTML_lTxt += '<meta charset="utf-8">';
        BodyHTML_lTxt += '<title>A simple, clean, and responsive HTML invoice template</title>';

        BodyHTML_lTxt += '<style>';
        BodyHTML_lTxt += '.invoice-box {';
        BodyHTML_lTxt += 'max-width: 800px;';
        BodyHTML_lTxt += 'margin: auto;';
        BodyHTML_lTxt += 'padding: 30px;';
        BodyHTML_lTxt += 'border: 1px solid #eee;';
        BodyHTML_lTxt += 'box-shadow: 0 0 10px rgba(0, 0, 0, .15;';
        BodyHTML_lTxt += 'font-size: 16px;';
        BodyHTML_lTxt += 'line-height: 24px;';
        BodyHTML_lTxt += 'font-family: ''Helvetica Neue'', ''Helvetica'', Helvetica, Arial, sans-serif;';
        BodyHTML_lTxt += 'color: #555;';
        BodyHTML_lTxt += '}';

        BodyHTML_lTxt += '.invoice-box table {';
        BodyHTML_lTxt += 'width: 100%;';
        BodyHTML_lTxt += 'line-height: inherit;';
        BodyHTML_lTxt += 'text-align: left;';
        BodyHTML_lTxt += '}';

        BodyHTML_lTxt += '.invoice-box table td {';
        BodyHTML_lTxt += 'padding: 5px;';
        BodyHTML_lTxt += 'vertical-align: top;';
        BodyHTML_lTxt += '}';

        BodyHTML_lTxt += '.invoice-box table tr td:nth-child(2) {';
        BodyHTML_lTxt += 'text-align: right;';
        BodyHTML_lTxt += '}';

        BodyHTML_lTxt += '.invoice-box table tr.top table td {';
        BodyHTML_lTxt += 'padding-bottom: 20px;';
        BodyHTML_lTxt += '}';

        BodyHTML_lTxt += '.invoice-box table tr.top table td.title {';
        BodyHTML_lTxt += 'font-size: 45px;';
        BodyHTML_lTxt += 'line-height: 45px;';
        BodyHTML_lTxt += 'color: #333;';
        BodyHTML_lTxt += '}';

        BodyHTML_lTxt += '.invoice-box table tr.information table td {';
        BodyHTML_lTxt += 'padding-bottom: 40px;';
        BodyHTML_lTxt += '}';

        BodyHTML_lTxt += '.invoice-box table tr.heading td {';
        BodyHTML_lTxt += 'background: #eee;';
        BodyHTML_lTxt += 'border-bottom: 1px solid #ddd;';
        BodyHTML_lTxt += 'font-weight: bold;';
        BodyHTML_lTxt += '}';

        BodyHTML_lTxt += '.invoice-box table tr.details td {';
        BodyHTML_lTxt += 'padding-bottom: 20px;';
        BodyHTML_lTxt += '}';

        BodyHTML_lTxt += '.invoice-box table tr.item td{';
        BodyHTML_lTxt += 'border-bottom: 1px solid #eee;';
        BodyHTML_lTxt += '}';

        BodyHTML_lTxt += '.invoice-box table tr.item.last td {';
        BodyHTML_lTxt += 'border-bottom: none;';
        BodyHTML_lTxt += '}';

        BodyHTML_lTxt += '.invoice-box table tr.total td:nth-child(2) {';
        BodyHTML_lTxt += 'border-top: 2px solid #eee;';
        BodyHTML_lTxt += 'font-weight: bold;';
        BodyHTML_lTxt += '}';

        BodyHTML_lTxt += '@media only screen and (max-width: 600px) {';
        BodyHTML_lTxt += '.invoice-box table tr.top table td {';
        BodyHTML_lTxt += 'width: 100%;';
        BodyHTML_lTxt += 'display: block;';
        BodyHTML_lTxt += 'text-align: center;';
        BodyHTML_lTxt += '}';

        BodyHTML_lTxt += '.invoice-box table tr.information table td {';
        BodyHTML_lTxt += 'width: 100%;';
        BodyHTML_lTxt += 'display: block;';
        BodyHTML_lTxt += 'text-align: center;';
        BodyHTML_lTxt += '}';
        BodyHTML_lTxt += '}';

        BodyHTML_lTxt += '/** RTL **/';
        BodyHTML_lTxt += '.rtl {';
        BodyHTML_lTxt += 'direction: rtl;';
        BodyHTML_lTxt += 'font-family: Tahoma, ''Helvetica Neue'', ''Helvetica'', Helvetica, Arial, sans-serif;';
        BodyHTML_lTxt += '}';

        BodyHTML_lTxt += '.rtl table {';
        BodyHTML_lTxt += 'text-align: right;';
        BodyHTML_lTxt += '}';

        BodyHTML_lTxt += '.rtl table tr td:nth-child(2) {';
        BodyHTML_lTxt += 'text-align: left;';
        BodyHTML_lTxt += '}';
        BodyHTML_lTxt += '</style>';
        BodyHTML_lTxt += '</head>';

        BodyHTML_lTxt += '<body>';
        BodyHTML_lTxt += '<div class="invoice-box">';
        BodyHTML_lTxt += '<table cellpadding="0" cellspacing="0">';
        BodyHTML_lTxt += '<tr class="top">';
        BodyHTML_lTxt += '<td colspan="2">';
        BodyHTML_lTxt += '<table>';
        BodyHTML_lTxt += '<tr>';
        BodyHTML_lTxt += '<td>';
        BodyHTML_lTxt += '<img src="https://106c4.wpc.azureedge.net/80106C4/Gallery-Prod/cdn/2015-02-24/prod20161101-microsoft-windowsazure-gallery/microsoftdynsmb.3a67602d-0a4f-4ae4-ad03-c1124f6ac3cf.1.0.2/Icon/large.png" height="100" width="100">';
        BodyHTML_lTxt += '</td>';

        BodyHTML_lTxt += '<td class="title">';
        BodyHTML_lTxt += '<b><font size = "5">Purchase Receipt</font></b><br>';
        BodyHTML_lTxt += '</td>';
        BodyHTML_lTxt += '</tr>';
        BodyHTML_lTxt += '</table>';
        BodyHTML_lTxt += '</td>';
        BodyHTML_lTxt += '</tr>';

        BodyHTML_lTxt += '<tr class="information">';
        BodyHTML_lTxt += '<td colspan="2">';
        BodyHTML_lTxt += '<table>';
        BodyHTML_lTxt += '<tr>';
        BodyHTML_lTxt += '<td>';
        BodyHTML_lTxt += CompanyInfo.Name + '<br>';
        BodyHTML_lTxt += CompanyInfo.Address + '<br>';
        BodyHTML_lTxt += CompanyInfo."Address 2" + '<br>';
        BodyHTML_lTxt += CompanyInfo.City + '<br>';
        BodyHTML_lTxt += CompanyInfo."Post Code" + '<br>';
        BodyHTML_lTxt += CompanyInfo."Phone No." + '<br>';
        BodyHTML_lTxt += '</td>';

        BodyHTML_lTxt += '<td>';
        BodyHTML_lTxt += CompanyInfo."Contact Person" + '<br>';
        BodyHTML_lTxt += CompanyInfo."E-Mail" + '<br>';
        BodyHTML_lTxt += 'Created Date:' + Format(CurrentDateTime()) + '<br>';
        BodyHTML_lTxt += '</td>';
        BodyHTML_lTxt += '</tr>';
        BodyHTML_lTxt += '</table>';
        BodyHTML_lTxt += '</td>';
        BodyHTML_lTxt += '</tr>';

        BodyHTML_lTxt += '<tr class="heading">';
        BodyHTML_lTxt += '<td>';
        BodyHTML_lTxt += 'Account No.';
        BodyHTML_lTxt += '</td>';

        BodyHTML_lTxt += '<td>';
        BodyHTML_lTxt += Vendor."No.";
        BodyHTML_lTxt += '</td>';
        BodyHTML_lTxt += '</tr>';

        BodyHTML_lTxt += '<tr class="details">';
        BodyHTML_lTxt += '<td>';
        BodyHTML_lTxt += 'Name';
        BodyHTML_lTxt += '</td>';

        BodyHTML_lTxt += '<td>';
        BodyHTML_lTxt += Vendor.Name;
        BodyHTML_lTxt += '</td>';
        BodyHTML_lTxt += '</tr>';

        BodyHTML_lTxt += '<tr class="heading">';
        BodyHTML_lTxt += '<td>';
        BodyHTML_lTxt += 'Details:';
        BodyHTML_lTxt += '</td>';

        BodyHTML_lTxt += '<td>';
        BodyHTML_lTxt += '';
        BodyHTML_lTxt += '</td>';
        BodyHTML_lTxt += '</tr>';

        BodyHTML_lTxt += '<tr class="item">';
        BodyHTML_lTxt += '<td>';
        BodyHTML_lTxt += 'Document No.';
        BodyHTML_lTxt += '</td>';

        BodyHTML_lTxt += '<td>';
        BodyHTML_lTxt += DocumentNo_iCod;
        BodyHTML_lTxt += '</td>';
        BodyHTML_lTxt += '</tr>';

        BodyHTML_lTxt += '<tr class="item">';
        BodyHTML_lTxt += '<td>';
        BodyHTML_lTxt += 'Order Date';
        BodyHTML_lTxt += '</td>';

        BodyHTML_lTxt += '<td>';
        BodyHTML_lTxt += Format(PurchRcptHeader_lRec."Order Date");
        BodyHTML_lTxt += '</td>';
        BodyHTML_lTxt += '</tr>';

        BodyHTML_lTxt += '<tr class="item last">';
        BodyHTML_lTxt += '<td>';
        BodyHTML_lTxt += '';
        BodyHTML_lTxt += '</td>';

        BodyHTML_lTxt += '<td>';
        BodyHTML_lTxt += '</td>';
        BodyHTML_lTxt += '</tr>';

        // BodyHTML_lTxt += '<tr class="heading">';
        // BodyHTML_lTxt += '<td>';
        // BodyHTML_lTxt += 'Total';
        // BodyHTML_lTxt += '</td>';

        // BodyHTML_lTxt += '<td>';
        // BodyHTML_lTxt += format(PurchRcptHeader_lRec."Amount Including VAT");
        // BodyHTML_lTxt += '</td>';
        // BodyHTML_lTxt += '</tr>';

        BodyHTML_lTxt += '</table>';
        BodyHTML_lTxt += '</div>';
        BodyHTML_lTxt += '</body>';
        BodyHTML_lTxt += '</html>';
        BodyHTML_lTxt += '<br><br>Kindly go through attached Document for more details.';
        BodyHTML_lTxt += '<br><br>Regards,<br><b>';
        BodyHTML_lTxt += CompanyInfo."Contact Person" + '<br>';
        BodyHTML_lTxt += CompanyInfo.Name + '<br>';
        BodyHTML_lTxt += CompanyInfo.Address + '<br>';
        BodyHTML_lTxt += CompanyInfo."Address 2" + '<br>';
        BodyHTML_lTxt += CompanyInfo.City + ',';
        BodyHTML_lTxt += CompanyInfo."Post Code" + '<br>';
        BodyHTML_lTxt += CompanyInfo."Phone No." + '<br>';
        BodyHTML_lTxt += CompanyInfo."E-Mail" + '<br></b>';

        WebPortalSetup_gRec.Get();
        if WebPortalSetup_gRec."Email as CC for Cust/Vend" then begin
            Clear(Recepients);
            Recepients.Add(Vendor."E-Mail");
            CC.Add(Vendor."E-Mail");
        end;
        EmailMessage.Create(Recepients, 'D365 Business Central', BodyHTML_lTxt, true, CC, BCC);

        XMLParameter := '<?xml version="1.0" standalone="yes"?><ReportParameters name="Purchase - Receipt" id="408"><Options><Field name="NoOfCopies">0</Field><Field name="ShowInternalInfo">false</Field><Field name="LogInteraction">true</Field><Field name="ShowCorrectionLines">false</Field></Options><DataItems><DataItem name="Purch. Rcpt. Header">VERSION(1) SORTING(Field3) WHERE(Field3=1(' + PurchRcptHeader_lRec."No." + '))</DataItem><DataItem name="CopyLoop">VERSION(1) SORTING(Field1)</DataItem><DataItem name="PageLoop">VERSION(1) SORTING(Field1)</DataItem><DataItem name="DimensionLoop1">VERSION(1) SORTING(Field1)</DataItem><DataItem name="Purch. Rcpt. Line">VERSION(1) SORTING(Field3,Field4)</DataItem><DataItem name="DimensionLoop2">VERSION(1) SORTING(Field1)</DataItem><DataItem name="Total">VERSION(1) SORTING(Field1)</DataItem><DataItem name="Total2">VERSION(1) SORTING(Field1)</DataItem></DataItems></ReportParameters>';

        TempBlob.CreateOutStream(EmailoutStream);


        Report.SaveAs(408, XMLParameter, ReportFormat::Pdf, EmailoutStream);
        TempBlob.CreateInStream(EmailInStream);
        EmailMessage.AddAttachment('PostedPurchaseReceipt' + DocumentNo_iCod + '.pdf', 'PDF', EmailInStream);

        // if SMTPMail.TrySend() then begin
        //     Message('Email Sent Successfully');
        //     exit(true);
        // end;

        Clear(Email);
        if Email.Send(EmailMessage, Enum::"Email Scenario"::Default) then begin
            if GuiAllowed then
                Message('Email Sent Successfully');
            exit(true);
        end;
    end;

}

