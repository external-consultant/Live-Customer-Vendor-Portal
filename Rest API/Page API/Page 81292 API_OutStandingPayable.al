page 81292 "API_OutStandingPayable"
{
    // version WebPortal
    APIGroup = 'API';
    APIPublisher = 'ISPL';
    APIVersion = 'v2.0';
    Caption = 'apiOutstandingPayable';
    DelayedInsert = true;
    EntityName = 'apiOutstandingPayable';
    EntityCaption = 'apiOutstandingPayable';
    EntitySetName = 'apiOutstandingPayables';    //Make Sure First Char in Small Letter and don't use any special char or space
    EntitySetCaption = 'apiOutstandingPayables';
    PageType = API;
    SourceTable = "Vendor Ledger Entry";
    SourceTableView = where("Remaining Amount" = filter(<> 0), "Document Type" = filter(Invoice), "Due Date" = filter('<Today'), Open = const(true)); // #filter baki duedate < today

    layout
    {
        area(Content)
        {
            repeater(Group)
            {
                field(vendorNo; Rec."Vendor No.")
                {
                    Caption = 'Vendor No.';
                }
                field(postingDate; Rec."Posting Date")
                {
                    Caption = 'Posting Date';
                }
                field(dueDate; Rec."Due Date")
                {
                    Caption = 'Due Date';
                }
                field(externalDocumentNo; Rec."External Document No.")
                {
                    Caption = 'External Document No.';
                }
                field(documentNo; Rec."Document No.")
                {
                    Caption = 'Document No.';
                }
                field(totalTDSIncludingSHECESS; Rec."Total TDS Including SHE CESS")
                {
                    Caption = 'Total TDS Including SHE CESS';
                }
                field(amount; Rec.Amount)
                {
                    Visible = false;
                    Caption = 'Amount';
                }
                field(remainingAmount; Rec."Remaining Amount")
                {
                    Visible = false;
                    Caption = 'Remaining Amount';
                }
                field(remainingamount_gDec; remainingamount_gDec)
                {
                }
                field(amount_gDec; amount_gDec)
                {

                }
                field(CurrencyCode_gCode; CurrencyCode_gCode)
                {

                }
            }
        }
    }

    trigger OnAfterGetRecord()
    var
        GenralLedgSetup_lRec: Record "General Ledger Setup";
    begin
        Clear(CurrencyCode_gCode);

        if Rec."Currency Code" = '' then begin
            GenralLedgSetup_lRec.Get();
            CurrencyCode_gCode := GenralLedgSetup_lRec."LCY Code";
        end else begin
            CurrencyCode_gCode := Rec."Currency Code";
        end;

        if Rec."Document Type" = Rec."Document Type"::Invoice then begin
            remainingamount_gDec := (Rec."Remaining Amount") * -1;
            amount_gDec := Rec.Amount * -1;
        end;

    end;

    trigger OnOpenPage()
    var
        INTKeyValidationMgt: Codeunit "IKV Mgt";
    begin
        Clear(INTKeyValidationMgt);
        INTKeyValidationMgt.onOpenPageKeyValidation();
        // Rec.SetCurrentKey("Posting Date");
        Rec.Ascending(false);

        Clear(INTKeyValidationMgt);
        INTKeyValidationMgt.onOpenPageKeyValidation();

        // Clear(remainingamount_gDec);
        // Clear(amount_gDec);

    end;

    var
        PurchaserName_gTxt: Text;
        PaymentTermsDescription_gTxt: Text;
        CurrencyCode_gCode: Code[10];
        PurchaserCode_gCode: Code[20];
        PurchaserDesc_gTxt: Text;
        QuoteNo_gCode: Code[20];
        PaymentTermsDesc_gTxt: Text;
        PaymentTermsCode_gCode: Code[20];
        VendorInvoiceNo_gDec: Code[20];
        GSTAmount_gDec: Decimal;
        DueDate_gDate: Date;
        NetAmount_gDec: Decimal;
        TDSAmount_gDec: Decimal;
        remainingamount_gDec: Decimal;
        amount_gDec: Decimal;
}
