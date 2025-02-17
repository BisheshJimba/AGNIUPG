page 25006168 "Vehicle No. Series Setup"
{
    // 16.02.2015 EB.P7 #T022
    //   Page created for Vehicle Serial No. hiding functionality

    Caption = 'Vehicle No. Series Setup';
    DeleteAllowed = false;
    InsertAllowed = false;
    PageType = ListPlus;
    SourceTable = Table313;

    layout
    {
        area(content)
        {
            group(Numbering)
            {
                Caption = 'Numbering';
                InstructionalText = 'To fill the Vehicle Serial No. field automatically, you must set up a number series.';
                field("Vehicle Serial No. Nos."; "Vehicle Serial No. Nos.")
                {
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
            action(Setup)
            {
                Caption = 'Sales & Receivables Setup';
                Image = Setup;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                RunObject = Page 459;
            }
        }
    }
}

