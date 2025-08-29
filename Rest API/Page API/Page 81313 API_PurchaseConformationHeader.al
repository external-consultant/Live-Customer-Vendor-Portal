page 81313 "API_PurchaseConformationHeader"
{
    // version WebPortal
    APIGroup = 'API';
    APIPublisher = 'ISPL';
    APIVersion = 'v2.0';
    Caption = 'apiPurchaseConformationHeader';
    DelayedInsert = true;
    EntityName = 'apiPurchaseConformationHeader';
    EntityCaption = 'apiPurchaseConformationHeader';
    EntitySetName = 'apiPurchaseConformationHeaders';    //Make Sure First Char in Small Letter and don't use any special char or space
    EntitySetCaption = 'apiPurchaseConformationHeaders';
    PageType = API;
    SourceTable = API_PurchaseConformationHeader;
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
                field(orderConfirmed; Rec."Order Confirmed")
                {
                    Caption = 'Order Confirmed';
                }
                field(conformationRemarks; Rec."Conformation Remarks")
                {
                    Caption = 'Conformation Remarks';
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

        Rec.TestField("Order Confirmed");
        Rec.TestField("Document No");
        Rec.TestField("Conformation Remarks");

        Clear(PurchaseHeader_gRec);
        if PurchaseHeader_gRec.Get(PurchaseHeader_gRec."Document Type"::Order, Rec."Document No") then begin

            PurchaseHeader_gRec."Order Confirmed" := true;
            PurchaseHeader_gRec."Order Confirmed Date" := Today;
            PurchaseHeader_gRec."Comformation Remarks" := Rec."Conformation Remarks";

            PurchaseHeader_gRec.Modify();
            Rec."Process Status" := Rec."Process Status"::Success;

        end else begin

            Error('Purchase Header with No %1 Not Found', Rec."Document No");
            Rec."Process Status" := Rec."Process Status"::Failed;
            Rec."Process Error Log" := 'Purchase Header with No ' + Rec."Document No" + ' Not Found';

        end;

    end;

    var

        PurchaseHeader_gRec: Record "Purchase Header";

}
