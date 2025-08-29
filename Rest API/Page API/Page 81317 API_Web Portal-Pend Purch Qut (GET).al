page 81317 "API_Web Portal-Pend Purch Qut"
{
    //T13751-N
    // version WebPortal
    APIGroup = 'API';
    APIPublisher = 'ISPL';
    APIVersion = 'v2.0';
    Caption = 'apiWebPortalPendPurchQuote';
    DelayedInsert = true;
    EntityName = 'apiWebPortalPendQuote';
    EntityCaption = 'apiWebPortalPendPurchQuote';
    EntitySetName = 'apiWebPortalPendPurchQuotes';    //Make Sure First Char in Small Letter and don't use any special char or space
    EntitySetCaption = 'apiWebPortalPendPurchQuote';
    PageType = API;
    SourceTable = "Purchase Line";

    layout
    {
        area(Content)
        {
            repeater(Group)
            {
                field(documentNo; Rec."Document No.")
                {
                    ApplicationArea = All;
                    Caption = 'Document No.';
                    ToolTip = 'Specifies the document number.';
                }
                field(lineNo; Rec."Line No.")
                {
                    Caption = 'Line No.';
                }
                field(buyfromVendorNo; Rec."Buy-from Vendor No.")
                {
                    ApplicationArea = All;
                    Caption = 'Buy-from Vendor No.';
                    ToolTip = 'Specifies the name of the vendor who delivered the items.';
                }
                field(orderNo_gCod; OrderNo_gCod)
                {
                    ApplicationArea = All;
                    Caption = 'Order No.';
                    ToolTip = 'Specifies the value of the Order No. field.';
                }
                field(documentDate; DocumentDate_gDte)
                {
                    ApplicationArea = All;
                    Caption = 'Document Date';
                    Editable = false;
                    ToolTip = 'Specifies the value of the Document Date field.';
                }
                field(type; Rec.Type)
                {
                    ApplicationArea = All;
                    Caption = 'Type';
                    ToolTip = 'Specifies the line type.';
                }
                field(no; Rec."No.")
                {
                    ApplicationArea = All;
                    Caption = 'No.';
                    ToolTip = 'Specifies the number of the involved entry or record, according to the specified number series.';
                }

                field(description; Rec.Description)
                {
                    ApplicationArea = All;
                    Caption = 'Description';
                    ToolTip = 'Specifies a description of the blanket purchase order.';
                }
                field("description2"; Rec."Description 2")
                {
                    ApplicationArea = All;
                    Caption = 'Description 2';
                    ToolTip = 'Specifies information in addition to the description.';
                }
                field(quantity; Rec.Quantity)
                {
                    ApplicationArea = All;
                    Caption = 'Quantity';
                    ToolTip = 'Specifies the quantity of the purchase order line.';
                }
                field(etd; Rec.CustomETD)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the date you expect the items to be available in your warehouse.';
                }
                field(unitOfMeasureCode; Rec."Unit of Measure Code")
                {
                    Caption = 'Unit of Measure Code';
                }
                field(directUnitCost; Rec."Direct Unit Cost")
                {
                    Caption = 'Direct Unit Cost';
                }
                field(amount; Rec.Amount)
                {
                    Caption = 'Amount';
                }
                field(currencyCode; CurrencyCode_gCode)
                {
                    Caption = 'Currency Code';
                }

            }
        }
    }

    trigger OnAfterGetRecord()
    var
        PurchHdr_lRec: Record "Purchase Header";
        GenralLedgSetup_lRec: Record "General Ledger Setup";
    begin
        Clear(CurrencyCode_gCode);
        OrderNo_gCod := '';
        DocumentDate_gDte := 0D;

        Clear(PurchHdr_lRec);
        if PurchHdr_lRec.Get(Rec."Document Type", Rec."Document No.") then begin
            OrderNo_gCod := PurchHdr_lRec."Vendor Order No.";
            DocumentDate_gDte := PurchHdr_lRec."Document Date";
        end;

        if Rec."Currency Code" = '' then begin
            GenralLedgSetup_lRec.Get();
            CurrencyCode_gCode := GenralLedgSetup_lRec."LCY Code";
        end else begin
            CurrencyCode_gCode := Rec."Currency Code";
        end;
    end;

    trigger OnOpenPage()
    var
        INTKeyValidationMgt: Codeunit "IKV Mgt";
    begin
        Clear(INTKeyValidationMgt);
        INTKeyValidationMgt.onOpenPageKeyValidation();

        //T39004-NS NG 08092023
        IF Rec.GETFILTER("Buy-from Vendor No.") = '' THEN
            ERROR('Apply Vendor filter Require, (Referesh Browser and Login again)');
        //T39004-NE

        Rec.SetRange("Document Type", Rec."Document Type"::Quote);
    end;

    var
        OrderNo_gCod: Code[35];
        DocumentDate_gDte: Date;
        CurrencyCode_gCode: Code[10];
}