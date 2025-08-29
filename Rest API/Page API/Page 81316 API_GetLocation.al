page 81316 "API_GetLocation"
{
    // version WebPortal
    APIGroup = 'API';
    APIPublisher = 'ISPL';
    APIVersion = 'v2.0';
    Caption = 'apiGetLocation';
    DelayedInsert = true;
    EntityName = 'apiGetLocation';
    EntityCaption = 'apiGetLocation';
    EntitySetName = 'apiGetLocations';    //Make Sure First Char in Small Letter and don't use any special char or space
    EntitySetCaption = 'apiGetLocations';
    PageType = API;
    SourceTable = Location;

    layout
    {
        area(Content)
        {
            repeater(Group)
            {
               
                field("code"; Rec."Code")
                {
                    Caption = 'Code';
                }
                field(name; Rec.Name)
                {
                    Caption = 'Name';
                }
                field(name2; Rec."Name 2")
                {
                    Caption = 'Name 2';
                }
            }
        }
    }

   
}
