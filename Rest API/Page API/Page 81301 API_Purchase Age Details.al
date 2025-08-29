page 81301 "API_Purchase Age Details"
{
    // version WebPortal
    APIGroup = 'API';
    APIPublisher = 'ISPL';
    APIVersion = 'v2.0';
    Caption = 'apiPurchasedetail';
    DelayedInsert = true;
    EntityName = 'apiPurchasedetail';
    EntityCaption = 'apiPurchasedetail';
    EntitySetName = 'apiPurchasedetails';    //Make Sure First Char in Small Letter and don't use any special char or space
    EntitySetCaption = 'apiPurchasedetails';
    PageType = API;
    SourceTable = "Age Details";
    SourceTableView = where(Source = filter('Purchases'));

    layout
    {
        area(Content)
        {
            repeater(Group)
            {
                field(startDate; Rec."Start Date")
                {
                    Caption = 'Start Date';
                }
                field(endDate; Rec."End Date")
                {
                    Caption = 'End Date';
                }
                field(amount; Rec.Amount)
                {
                    Caption = 'Amount';
                }
                field(ageBy; Rec."Age by")
                {
                    Caption = 'Age by';
                }
                field(caption; Rec.Caption)
                {
                    Caption = 'Caption';
                }
                field(year; Rec.CaptionYear)
                {
                    Caption = 'CaptionYear';
                }

                field(sequence; Rec.Sequence)
                {
                    Caption = 'Sequence';
                }
                field(source; Rec.Source)
                {
                    Caption = 'Source';
                }
                field(vendorNo; Rec."No.")
                {
                    Caption = 'Vendor No.';
                }
                field(GLSLocalCurrencySymbol_gTxt; GLSLocalCurrencySymbol_gTxt)
                {

                }
                field(GLSLcyCode; GLSLcyCode)
                {

                }
            }
        }
    }

    trigger OnAfterGetRecord()
    var
        myInt: Integer;
        GeneralLedgerSetup_lRec: Record "General Ledger Setup";
    begin
        GeneralLedgerSetup_lRec.Reset();
        GeneralLedgerSetup_lRec.Get();
        GLSLocalCurrencySymbol_gTxt := GeneralLedgerSetup_lRec."Local Currency Symbol";
        GLSLcyCode := GeneralLedgerSetup_lRec."LCY Code";
    end;

    var
        ExternalDocumentNo_gCode: Code[35];
        GLSLocalCurrencySymbol_gTxt: Text;
        GLSLcyCode: Code[20];

}
