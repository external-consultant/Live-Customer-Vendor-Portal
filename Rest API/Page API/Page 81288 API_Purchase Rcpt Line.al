page 81288 "API_Purchase Rcpt Line"
{
    // version WebPortal
    APIGroup = 'API';
    APIPublisher = 'ISPL';
    APIVersion = 'v2.0';
    Caption = 'apiPurchaseRcptLine';
    DelayedInsert = true;
    EntityName = 'apiPurchaseRcptLine';
    EntityCaption = 'apiPurchaseRcptLine';
    EntitySetName = 'apiPurchaseRcptLines';    //Make Sure First Char in Small Letter and don't use any special char or space
    EntitySetCaption = 'apiPurchaseRcptLines';
    PageType = API;
    SourceTable = "Purch. Rcpt. Line";
    SourceTableView = where(Correction = const(false), Quantity = filter(<> 0), Type = filter(<> ''));

    layout
    {
        area(Content)
        {
            repeater(Group)
            {
                field(buyFromVendorNo; Rec."Buy-from Vendor No.")
                {
                    Caption = 'Buy-from Vendor No.';
                }
                field(postingDate; Rec."Posting Date")
                {
                    Caption = 'Posting Date';
                }
                field(documentNo; Rec."Document No.")
                {
                    Caption = 'Document No.';
                }
                field(ShipmentNo_gCode; ShipmentNo_gCode)
                {
                    Caption = 'Vendor Shipment No.';
                }
                field(VendorOrderno_gCode; VendorOrderno_gCode)
                {
                    Caption = 'Vendor Order No.';
                }
                field(orderNo; Rec."Order No.")
                {
                    Caption = 'Order No.';
                }
                field(description; Rec.Description)
                {
                    Caption = 'Description';
                }
                field(description2; Rec."Description 2")
                {
                    Caption = 'Description 2';
                }
                field(quantity; Rec.Quantity)
                {
                    Caption = 'Quantity';
                }
                field(uom; Rec."Unit of Measure")
                {
                    Caption = 'Unit of Measure';
                }
            }
        }
    }

    trigger OnAfterGetRecord()
    var
        purchaseRcptHeader_lRec: Record "Purch. Rcpt. Header";
        BankACCLedEntry_lRec: Record "Bank Account Ledger Entry";
    begin
        Clear(ShipmentNo_gCode);
        Clear(VendorOrderno_gCode);

        purchaseRcptHeader_lRec.Reset();
        if purchaseRcptHeader_lRec.Get(Rec."Document No.") then begin
            ShipmentNo_gCode := purchaseRcptHeader_lRec."Vendor Shipment No.";
            VendorOrderno_gCode := purchaseRcptHeader_lRec."Vendor Order No.";
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
        CehckDate_gDate: Date;
        ShipmentNo_gCode: Code[20];
        VendorOrderno_gCode: Code[20];

}
