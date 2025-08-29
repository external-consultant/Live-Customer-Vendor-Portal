page 81298 "API_Sales Shipment Line"
{
    // version WebPortal
    APIGroup = 'API';
    APIPublisher = 'ISPL';
    APIVersion = 'v2.0';
    Caption = 'apiSalesShipmentLine';
    DelayedInsert = true;
    EntityName = 'apiSalesShipmentLine';
    EntityCaption = 'apiSalesShipmentLine';
    EntitySetName = 'apiSalesShipmentLines';    //Make Sure First Char in Small Letter and don't use any special char or space
    EntitySetCaption = 'apiSalesShipmentLines';
    PageType = API;
    SourceTable = "Sales Shipment Line";
    SourceTableView = where(Type = filter(<> ''), Correction = const(false), Quantity = filter(<> 0));

    layout
    {
        area(Content)
        {
            repeater(Group)
            {
                // field(no; Rec."No.")
                // {

                // }
                field(selltoCustomerNo; Rec."Sell-to Customer No.")
                {
                    Caption = 'Sell-to Customer No.';
                }
                field(shipmentDate; Rec."Posting Date")
                {
                    Caption = 'Shipment Date';
                }
                field(shipmentNo; Rec."Document No.")
                {
                    Caption = 'Shipment No.';
                }
                field(ExternalDocumentNo_gCode; ExternalDocumentNo_gCode)
                {
                    Caption = 'External Document No';
                }
                field(YourReferenceNo_gCode; YourReferenceNo_gTxt)
                {
                    Caption = 'Your Reference No';
                }
                // field(VendorOrderno_gCode; VendorOrderno_gCode)
                // {
                //     Caption = 'Vendor Order No.';
                // }
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
        SalesShipmentHeader_lRec: Record "Sales Shipment Header";
    begin
        Clear(ExternalDocumentNo_gCode);

        SalesShipmentHeader_lRec.Reset();
        if SalesShipmentHeader_lRec.Get(Rec."Document No.") then begin
            ExternalDocumentNo_gCode := SalesShipmentHeader_lRec."External Document No.";
            YourReferenceNo_gTxt := SalesShipmentHeader_lRec."Your Reference";
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
        ExternalDocumentNo_gCode: Code[35];
        YourReferenceNo_gTxt: Text[40];

}
