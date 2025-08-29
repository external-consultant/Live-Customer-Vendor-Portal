page 81311 "API_GetSalesLine"
{
    // version WebPortal
    APIGroup = 'API';
    APIPublisher = 'ISPL';
    APIVersion = 'v2.0';
    Caption = 'apiGetSalesLine';
    DelayedInsert = true;
    EntityName = 'apiGetSalesLine';
    EntityCaption = 'apiGetSalesLine';
    EntitySetName = 'apiGetSalesLines';    //Make Sure First Char in Small Letter and don't use any special char or space
    EntitySetCaption = 'apiGetSalesLines';
    PageType = API;
    SourceTable = "Sales Line";
    SourceTableView = where("Document Type" = filter(Order), Quantity = filter(<> 0), Type = filter(<> ''));

    layout
    {
        area(Content)
        {
            repeater(Group)
            {
                field(unitOfMeasure; Rec."Unit of Measure")
                {
                    Caption = 'Unit of Measure';
                }

                field(documentNo; Rec."Document No.")
                {
                    Caption = 'Document No.';
                }
                field(documentType; Rec."Document Type")
                {
                    Caption = 'Document Type';
                }
                field("type"; Rec."Type")
                {
                    Caption = 'Type';
                }
                field(lineNo; Rec."Line No.")
                {
                    Caption = 'Line No.';
                }
                field(no; Rec."No.")
                {
                    Caption = 'No.';
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
                field(unitPrice; Rec."Unit Price")
                {
                    Caption = 'Unit Price';
                }
                field(lineAmount; Rec."Line Amount")
                {
                    Caption = 'Line Amount';
                }
                field(lineDiscountAmount; Rec."Line Discount Amount")
                {
                    Caption = 'Line Discount Amount';
                }
                field(locationCode; Rec."Location Code")
                {
                    Caption = 'Location Code';
                }
                field(amount; Rec.Amount)
                {
                    Caption = 'Amount';
                }


            }
        }
    }

    trigger OnOpenPage()
    var
    begin
        IF Rec.GETFILTER("Document No.") = '' THEN
            ERROR('Document No Filter Required');
    end;
}
