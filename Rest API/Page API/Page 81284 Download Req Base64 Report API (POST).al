page 81284 "Download Req Base64 Report API"
{
    APIGroup = 'API';
    APIPublisher = 'ISPL';
    APIVersion = 'v2.0';
    Caption = 'apiDownloadReqB64ReportAPI';
    DelayedInsert = true;
    EntityName = 'apiDownloadReqB64ReportAPI';
    EntityCaption = 'apiDownloadReqB64ReportAPI';
    EntitySetName = 'apiDownloadReqB64ReportAPIs';          //Make Sure First Char in Small Letter and don't use any special char or space
    EntitySetCaption = 'apiDownloadReqB64ReportAPIs';
    PageType = API;
    SourceTable = ReportDownloadRequest;

    layout
    {
        area(content)
        {
            repeater(General)
            {
                field(entryNo; Rec."Entry No.")
                {
                    Caption = 'Entry No.';
                }
                field(reportName; Rec.ReportName)
                {
                    Caption = 'ReportName';
                }
                field(reportDocumentNo; Rec."Report Document No.")
                {
                    Caption = 'Report Document No.';
                }
                field(startDate; Rec.StartDate)
                {
                    Caption = 'StartDate';
                }
                field(endDate; Rec.EndDate)
                {
                    Caption = 'EndDate';
                }
            }
        }
    }

    trigger OnInsertRecord(BelowxRec: Boolean): Boolean
    var
        ReportDownloadReq_lRec: Record ReportDownloadRequest;
    begin

        Rec.TestField(ReportName);
        Rec.TestField("Report Document No.");

        clear(ReportDownloadReq_lRec);
        ReportDownloadReq_lRec.Init();
        ReportDownloadReq_lRec.Validate(ReportName, Rec.ReportName);
        ReportDownloadReq_lRec.Validate("Report Document No.", Rec."Report Document No.");
        ReportDownloadReq_lRec.Validate(StartDate, Rec.StartDate);
        ReportDownloadReq_lRec.Validate(EndDate, Rec.EndDate);
        ReportDownloadReq_lRec.Insert();

    end;



}
