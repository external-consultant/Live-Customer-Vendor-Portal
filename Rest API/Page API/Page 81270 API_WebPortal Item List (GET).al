page 81270 "API_WebPortal Item List"
{
    // version WebPortal

    APIGroup = 'API';
    APIPublisher = 'ISPL';
    APIVersion = 'v2.0';
    Caption = 'apiWebPortalItemList';
    DelayedInsert = true;
    EntityName = 'apiWebPortalItemList';
    EntityCaption = 'apiWebPortalItemList';
    EntitySetName = 'apiWebPortalItemLists';    //Make Sure First Char in Small Letter and don't use any special char or space
    EntitySetCaption = 'apiWebPortalItemLists';
    PageType = API;
    SourceTable = Item;

    layout
    {
        area(Content)
        {
            repeater(Group)
            {
                field(no; Rec."No.")
                {
                    ApplicationArea = All;
                    Caption = 'No.';
                    ToolTip = 'Specifies the number of the item.';
                }
                field(description; Rec.Description)
                {
                    ApplicationArea = All;
                    Caption = 'Description';
                    ToolTip = 'Specifies what you are selling.';
                }
                field(description2; Rec."Description 2")
                {
                    ApplicationArea = All;
                    Caption = 'Description 2';
                    ToolTip = 'Specifies the value of the Description 2 field.';
                }
                field(baseUnitofMeasure; Rec."Base Unit of Measure")
                {
                    ApplicationArea = All;
                    Caption = 'Base Unit of Measure';
                    ToolTip = 'Specifies the unit in which the item is held in inventory. The base unit of measure also serves as the conversion basis for alternate units of measure.';
                }
            }
        }
    }

    trigger OnOpenPage()
    var
        INTKeyValidationMgt: Codeunit "IKV Mgt";
    begin
        Clear(INTKeyValidationMgt);
        INTKeyValidationMgt.onOpenPageKeyValidation();
    end;
}

