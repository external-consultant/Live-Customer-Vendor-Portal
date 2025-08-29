page 81283 "Download Base64 Report API"
{
    APIGroup = 'API';
    APIPublisher = 'ISPL';
    APIVersion = 'v2.0';
    Caption = 'apiDownloadReportB64API';
    DelayedInsert = true;
    EntityName = 'apiDownloadReportB64API';
    EntityCaption = 'apiDownloadReportB64API';
    EntitySetName = 'apiDownloadReportB64APIs';          //Make Sure First Char in Small Letter and don't use any special char or space
    EntitySetCaption = 'apiDownloadReportB64APIs';
    PageType = API;
    SourceTable = ReportDownloadRequest;
    InsertAllowed = false;
    DeleteAllowed = false;
    ModifyAllowed = false;

    layout
    {
        area(content)
        {
            repeater(General)
            {
                field(reportName; Rec.ReportName)
                {
                    Caption = 'ReportName';
                }
                field(reportDocumentNo; Rec."Report Document No.")
                {
                    Caption = 'Report Document No.';
                }
                field(startDateTxt; Rec.StartDate)
                {
                    Caption = 'StartDate';
                }
                field(endDateTxt; Rec.EndDate)
                {
                    Caption = 'EndDate';
                }
                field(reportB64_gTxt; ReportB64_gTxt)
                {
                    ApplicationArea = All;
                }
                field(fileName_gTxt; FileName_gTxt)
                {
                    ApplicationArea = All;
                }

            }
        }
    }

    trigger OnAfterGetRecord()
    var
        DownloadB64_lCud: Codeunit "INT Web Portal - Report Base64";
        StartdateTxt: Text;
    begin
        Case Rec.ReportName of
            'Posted Sales Invoice':
                begin
                    Clear(DownloadB64_lCud);
                    DownloadB64_lCud.PrintPostedSalesInvoice_gFnc(Rec."Report Document No.", ReportB64_gTxt, FileName_gTxt);
                end;

            'Posted Sales Credit Notes':
                begin
                    Clear(DownloadB64_lCud);
                    DownloadB64_lCud.PrintPostedSalesCreditNote_gFnc(Rec."Report Document No.", ReportB64_gTxt, FileName_gTxt);
                end;

            'Sales Order':
                begin
                    Clear(DownloadB64_lCud);
                    DownloadB64_lCud.PrintSalesOrder_gFnc(Rec."Report Document No.", ReportB64_gTxt, FileName_gTxt);
                end;

            'Posted Purchase Debit Note':
                begin
                    Clear(DownloadB64_lCud);
                    DownloadB64_lCud.PrintPostedPurchDebitNote_gFnc(Rec."Report Document No.", ReportB64_gTxt, FileName_gTxt);
                end;

            'Purchase Order':
                begin
                    Clear(DownloadB64_lCud);
                    DownloadB64_lCud.PrintPurchaseOrder_gFnc(Rec."Report Document No.", ReportB64_gTxt, FileName_gTxt);
                end;

            'Customer Statement':
                begin
                    Clear(DownloadB64_lCud);
                    DownloadB64_lCud.PrintCustomerStatement_gFnc(Rec."Report Document No.", Rec.StartDate, Rec.EndDate, ReportB64_gTxt, FileName_gTxt);
                end;

            'Customer Statement (Excel)':
                begin
                    Clear(DownloadB64_lCud);
                    DownloadB64_lCud.PrintCustomerStatementEXCEL_gFnc(Rec."Report Document No.", Rec.StartDate, Rec.EndDate, ReportB64_gTxt, FileName_gTxt);
                end;

            'Customer Statement D365':
                begin
                    Clear(DownloadB64_lCud);
                    DownloadB64_lCud.PrintCustomerStatementD365_gFnc(Rec."Report Document No.", Rec.StartDate, Rec.EndDate, ReportB64_gTxt, FileName_gTxt);
                end;

            'Customer Statement (Excel)(D365)':
                begin
                    Clear(DownloadB64_lCud);
                    DownloadB64_lCud.PrintCustomerStatementEXCELD365_gFnc(Rec."Report Document No.", Rec.StartDate, Rec.EndDate, ReportB64_gTxt, FileName_gTxt);
                end;

            'Vendor Statement':
                begin
                    Clear(DownloadB64_lCud);
                    DownloadB64_lCud.PrintVendorStatement_gFnc(Rec."Report Document No.", Rec.StartDate, Rec.EndDate, ReportB64_gTxt, FileName_gTxt);
                end;

            'Vendor Statement (Excel)':
                begin
                    Clear(DownloadB64_lCud);
                    DownloadB64_lCud.PrintVendorStatementEXCEL_gFnc(Rec."Report Document No.", Rec.StartDate, Rec.EndDate, ReportB64_gTxt, FileName_gTxt);
                end;

            'Vendor Statement (D365)':
                begin
                    Clear(DownloadB64_lCud);
                    DownloadB64_lCud.PrintVendorStatementD365_gFnc(Rec."Report Document No.", Rec.StartDate, Rec.EndDate, ReportB64_gTxt, FileName_gTxt);
                end;

            'Vendor Statement (EXCEL)(D365)':
                begin
                    Clear(DownloadB64_lCud);
                    DownloadB64_lCud.PrintVendorStatementEXCELD365_gFnc(Rec."Report Document No.", Rec.StartDate, Rec.EndDate, ReportB64_gTxt, FileName_gTxt);
                end;

            'Customer Payments':
                begin
                    Clear(DownloadB64_lCud);
                    DownloadB64_lCud.PrintCustomerPayments_gFnc(Rec."Report Document No.", ReportB64_gTxt, FileName_gTxt);
                end;

            'Vendor Payments':
                begin
                    Clear(DownloadB64_lCud);
                    DownloadB64_lCud.PrintVendorPayments_gFnc(Rec."Report Document No.", ReportB64_gTxt, FileName_gTxt);
                end;

            'Pending Sales Invoice':
                begin
                    Clear(DownloadB64_lCud);
                    DownloadB64_lCud.PrintPendingSalesInvoice_gFnc(Rec."Report Document No.", ReportB64_gTxt, FileName_gTxt);
                end;

            'Posted Purchase Invoice':
                begin
                    Clear(DownloadB64_lCud);
                    DownloadB64_lCud.PrintPostedPurchInvoice_gFnc(Rec."Report Document No.", ReportB64_gTxt, FileName_gTxt);
                end;

            'Posted Purchase Receipt':
                begin
                    Clear(DownloadB64_lCud);
                    DownloadB64_lCud.PrintPostedPurchRcpt_gFnc(Rec."Report Document No.", ReportB64_gTxt, FileName_gTxt);
                end;

            'Posted Sales Shipment':
                begin
                    Clear(DownloadB64_lCud);
                    DownloadB64_lCud.PrintPostedSalesShipment_gFnc(Rec."Report Document No.", ReportB64_gTxt, FileName_gTxt);
                end;

            'Purchase Quote':
                begin
                    Clear(DownloadB64_lCud);
                    DownloadB64_lCud.PrintPurchaseQuote_gFnc(Rec."Report Document No.", ReportB64_gTxt, FileName_gTxt);
                end;
            else
                Error('Case not define for Report Name %1', Rec.ReportName);
        End;
    end;



    var
        ReportB64_gTxt: Text;
        FileName_gTxt: Text;
        ReportName_gTxt: Text;

}
