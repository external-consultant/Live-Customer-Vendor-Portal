page 81296 "API_Customer OverDue"
{
    // version WebPortal
    APIGroup = 'API';
    APIPublisher = 'ISPL';
    APIVersion = 'v2.0';
    Caption = 'apiCustomerOverDue';
    DelayedInsert = true;
    EntityName = 'apiCustomerOverDue';
    EntityCaption = 'apiCustomerOverDue';
    EntitySetName = 'apiCustomerOverDues';    //Make Sure First Char in Small Letter and don't use any special char or space
    EntitySetCaption = 'apiCustomerOverDues';
    PageType = API;
    SourceTable = "Cust. Ledger Entry";
    SourceTableView = where("Remaining Amount" = filter(<> 0), "Document Type" = filter(Invoice), "Due Date" = filter('<Today'), Open = const(true)); // #filter baki duedate < today

    layout
    {
        area(Content)
        {
            repeater(Group)
            {
                field(customerNo; Rec."Customer No.")
                {
                    Caption = 'Customer No.';
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

                field(totalTCSIncludingSHECESS; TCSamountposamount_lDec)
                {
                    Caption = 'Total TCS Including SHE CESS';
                }
                field(amount; Rec.Amount)
                {
                    Caption = 'Amount';
                }
                field(remainingAmount; Rec."Remaining Amount")
                {
                    Caption = 'Remaining Amount';
                }
                field(CurrencyCode_gCode; CurrencyCode_gCode)
                {

                }
                field(negativeTCS; Rec."Total TCS Including SHE CESS")
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

        TCSamountposamount_lDec := Rec."Total TCS Including SHE CESS" * -1;
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

    end;

    var

        TCSamountposamount_lDec: Decimal;
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
}
