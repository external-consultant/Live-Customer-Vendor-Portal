page 81315 "API_PurchOrdShipmentStat"
{
    // version WebPortal
    APIGroup = 'API';
    APIPublisher = 'ISPL';
    APIVersion = 'v2.0';
    Caption = 'apiPurchOrdShipmentStat';
    DelayedInsert = true;
    EntityName = 'apiPurchOrdShipmentStat';
    EntityCaption = 'apiPurchOrdShipmentStat';
    EntitySetName = 'apiPurchOrdShipmentStats';    //Make Sure First Char in Small Letter and don't use any special char or space
    EntitySetCaption = 'apiPurchOrdShipmentStats';
    PageType = API;
    SourceTable = API_PurchOrderShipmentStat;
    SourceTableTemporary = true;

    layout
    {
        area(Content)
        {
            repeater(Group)
            {
                field(documentNo; Rec."Document No")
                {
                    Caption = 'Document No';
                }
                field(shipmentStatus; Rec."Shipment Status")
                {
                    Caption = 'Shipment Status';
                }
                field(shipmentMethod; Rec."Shipment Method")
                {
                    Caption = 'Shipment Method';
                }
                field(packageTrackingNo; Rec."Package Tracking No")
                {
                    Caption = 'Package Tracking No';
                }
                field(processStatus; Rec."Process Status")
                {
                    Caption = 'Process Status';
                }
                field(processErrorLog; Rec."Process Error Log")
                {
                    Caption = 'Process Error Log';
                }
            }
        }
    }

    trigger OnInsertRecord(BelowxRec: Boolean): Boolean
    begin

        Rec.TestField("Document No");
        Rec.TestField("Shipment Method");
        Rec.TestField("Package Tracking No");
        Rec.TestField("Shipment Status");

        Clear(PurchaseHeader_gRec);
        if PurchaseHeader_gRec.Get(PurchaseHeader_gRec."Document Type"::Order, Rec."Document No") then begin

            PurchaseHeader_gRec."Shipment Status" := Rec."Shipment Status";
            PurchaseHeader_gRec."Shipment Method" := Rec."Shipment Method";
            PurchaseHeader_gRec."Package Tracking No" := Rec."Package Tracking No";
            PurchaseHeader_gRec.Modify();

            Rec."Process Status" := Rec."Process Status"::Success;

        end else begin

            Error('Purchase Order with No %1 Not Found', Rec."Document No");
            Rec."Process Status" := Rec."Process Status"::Failed;
            Rec."Process Error Log" := 'Purchase Order with No ' + Rec."Document No" + ' Not Found';

        end;

    end;

    var

        PurchaseHeader_gRec: Record "Purchase Header";
}
