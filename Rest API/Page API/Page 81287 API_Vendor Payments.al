page 81287 "API_Vendor Payments"
{
    // version WebPortal
    APIGroup = 'API';
    APIPublisher = 'ISPL';
    APIVersion = 'v2.0';
    Caption = 'apiVendorPayments';
    DelayedInsert = true;
    EntityName = 'apiVendorPayments';
    EntityCaption = 'apiVendorPayments';
    EntitySetName = 'apiVendorPaymentss';    //Make Sure First Char in Small Letter and don't use any special char or space
    EntitySetCaption = 'apiVendorPaymentss';
    PageType = API;
    SourceTable = "Vendor Ledger Entry";
    SourceTableView = where("Document Type" = filter(Payment), Reversed = const(false));

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
                field(documentNo; Rec."Document No.")
                {
                    Caption = 'Document No.';
                }
                field(externalDocumentNo; Rec."External Document No.")
                {
                    Caption = 'External Document No.';
                }
                field(paymentReference; Rec."Payment Reference")
                {
                    Caption = 'Payment Reference';
                }
                field(currencyCode; CurrencyCode_gCode)
                {
                    Caption = 'Currency Code';
                }
                field(CheckNo_gCode; CheckNo_gCode)
                {
                    Caption = 'Check No';
                }
                field(CehckDate_gDate; CehckDate_gTxt)
                {
                    Caption = 'Check Date';
                }
                field(totalTDSIncludingSHECESS; Rec."Total TDS Including SHE CESS")
                {
                    Caption = 'Total TDS Including SHE CESS';
                }
                field(amount; Rec.Amount)
                {
                    Caption = 'Amount';
                }

            }
        }
    }

    trigger OnAfterGetRecord()
    var
        GenralLedgSetup_lRec: Record "General Ledger Setup";
        BankACCLedEntry_lRec: Record "Bank Account Ledger Entry";
    begin
        Clear(CurrencyCode_gCode);
        Clear(CheckNo_gCode);
        Clear(CehckDate_gTxt);

        if Rec."Currency Code" = '' then begin
            GenralLedgSetup_lRec.Get();
            CurrencyCode_gCode := GenralLedgSetup_lRec."LCY Code";
        end else begin
            CurrencyCode_gCode := Rec."Currency Code";
        end;

        if Rec."Bal. Account Type" = Rec."Bal. Account Type"::"Bank Account" then begin
            BankACCLedEntry_lRec.Reset();

            BankACCLedEntry_lRec.SetRange("Document No.", Rec."Document No.");
            BankACCLedEntry_lRec.SetRange("Posting Date", Rec."Posting Date");
            if BankACCLedEntry_lRec.FindFirst() then begin
                CheckNo_gCode := BankACCLedEntry_lRec."Cheque No.";
                CehckDate_gTxt := '';
                if BankACCLedEntry_lRec."Cheque Date" <> 0D then
                    CehckDate_gTxt := Format(BankACCLedEntry_lRec."Cheque Date"); // # baki
            end;
        end;

    end;

    trigger OnOpenPage()
    var
        INTKeyValidationMgt: Codeunit "IKV Mgt";
    begin
        Clear(INTKeyValidationMgt);
        INTKeyValidationMgt.onOpenPageKeyValidation();
        Rec.SetCurrentKey("Posting Date");
        Rec.Ascending(false);

        Clear(INTKeyValidationMgt);
        INTKeyValidationMgt.onOpenPageKeyValidation();

    end;

    var
        CheckNo_gCode: Code[20];
        CehckDate_gTxt: Text;
        CurrencyCode_gCode: Code[10];

}
