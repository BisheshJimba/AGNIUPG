page 25006523 "Vehicle Opt. Jnl. Batches"
{
    // 19.06.2013 EDMS P8
    //   * Merged with NAV2009
    // 
    // 19.06.2004 EDMS P1
    //    * Created

    Caption = 'Vehicle Option Journal Batches';
    DataCaptionExpression = fDataCaption;
    PageType = List;
    SourceTable = Table25006386;

    layout
    {
        area(content)
        {
            repeater()
            {
                field(Name; Name)
                {
                }
                field(Description; Description)
                {
                }
                field("No. Series"; "No. Series")
                {
                }
                field("Posting No. Series"; "Posting No. Series")
                {
                }
                field("Journal Template Name"; "Journal Template Name")
                {
                    Visible = false;
                }
            }
        }
    }

    actions
    {
        area(navigation)
        {
            group("P&osting")
            {
                Caption = 'P&osting';
                action("P&ost")
                {
                    Caption = 'P&ost';
                    Image = Post;
                    RunObject = Codeunit 25006311;
                    ShortCutKey = 'F11';
                }
                action("Post and &Print")
                {
                    Caption = 'Post and &Print';
                    Image = PostPrint;
                    RunObject = Codeunit 25006312;
                    ShortCutKey = 'Shift+F11';
                }
            }
        }
    }

    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        fSetupNewBatch;
    end;

    local procedure fDataCaption(): Text[250]
    var
        ItemJnlTemplate: Record "82";
    begin
        IF NOT CurrPage.LOOKUPMODE THEN
            IF GETFILTER("Journal Template Name") <> '' THEN
                IF GETRANGEMIN("Journal Template Name") = GETRANGEMAX("Journal Template Name") THEN
                    IF ItemJnlTemplate.GET(GETRANGEMIN("Journal Template Name")) THEN
                        EXIT(ItemJnlTemplate.Name + ' ' + ItemJnlTemplate.Description);
    end;
}

