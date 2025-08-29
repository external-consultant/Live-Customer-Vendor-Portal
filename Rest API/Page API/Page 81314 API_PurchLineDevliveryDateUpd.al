page 81314 "API_PurchLineDevliveryDateUpd"
{
    // version WebPortal
    APIGroup = 'API';
    APIPublisher = 'ISPL';
    APIVersion = 'v2.0';
    Caption = 'apiPurchLineDevliveryDateUpd';
    DelayedInsert = true;
    EntityName = 'apiPurchLineDevliveryDateUpd';
    EntityCaption = 'apiPurchLineDevliveryDateUpd';
    EntitySetName = 'apiPurchLineDevliveryDateUpds';    //Make Sure First Char in Small Letter and don't use any special char or space
    EntitySetCaption = 'apiPurchLineDevliveryDateUpds';
    PageType = API;
    SourceTable = API_PurchLineDeliveryDateUpd;
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
                field(lineNo; Rec."Line No")
                {
                    Caption = 'Line No';
                }
                field(estimatedDeliveryDate; Rec."Estimated Delivery Date")
                {
                    Caption = 'Estimated Delivery Date';
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
        Rec.TestField("Line No");
        Rec.TestField("Estimated Delivery Date");

        Clear(PurchaseLine_gDec);
        if PurchaseLine_gDec.Get(PurchaseLine_gDec."Document Type"::Order, Rec."Document No", Rec."Line No") then begin

            PurchaseLine_gDec."Expected Receipt Date" := Rec."Estimated Delivery Date";
            PurchaseLine_gDec.Modify();
            Rec."Process Status" := Rec."Process Status"::Success;

        end else begin

            Error('Purchase Line with Document No %1, Line No %2 Not Found', Rec."Document No", Rec."Line No");
            Rec."Process Status" := Rec."Process Status"::Failed;
            Rec."Process Error Log" := 'Purchase Line with Document No ' + Rec."Document No" + ',Line No' + Format(Rec."Line No") + ' Not Found';

        end;
        
    end;

    var

        PurchaseHeader_gRec: Record "Purchase Header";
        PurchaseLine_gDec: Record "Purchase Line";
}
