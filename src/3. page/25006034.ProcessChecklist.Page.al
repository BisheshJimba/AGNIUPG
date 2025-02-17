page 25006034 "Process Checklist"
{
    Caption = 'Inventory Checklist';
    DataCaptionFields = "No.", "Template Code";
    PageType = Card;
    PopulateAllFields = true;
    SourceTable = Table25006025;

    layout
    {
        area(content)
        {
            group(General)
            {
                Caption = 'General';
                field("No."; "No.")
                {

                    trigger OnAssistEdit()
                    begin
                        IF AssistEdit(xRec) THEN
                            CurrPage.UPDATE;
                    end;
                }
                field("Template Code"; "Template Code")
                {

                    trigger OnValidate()
                    begin
                        TemplateCodeOnAfterValidate;
                    end;
                }
                field(Description; Description)
                {
                }
                field("Process Date"; "Process Date")
                {
                }
                field("Vehicle Serial No."; "Vehicle Serial No.")
                {
                }
                field(VIN; VIN)
                {
                }
                field(Picture; Picture)
                {
                }
            }
            part(Lines; 25006035)
            {
                SubPageLink = Process Checklist No.=FIELD(No.);
            }
            group(Details)
            {
                Caption = 'Details';
                Visible = false;
                field("Source Type"; "Source Type")
                {
                }
                field("Source Subtype"; "Source Subtype")
                {
                }
                field("Source ID"; "Source ID")
                {
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
            action(Print)
            {
                Caption = 'Print';
                Image = Print;
                Promoted = true;
                PromotedCategory = "Report";
                PromotedIsBig = true;

                trigger OnAction()
                var
                    DocMgt: Codeunit "25006000";
                    RepSelect: Record "25006011";
                begin
                    DocMgt.PrintCurrentDoc(0, 0, 14, RepSelect);
                    DocMgt.SelectProcessChklistDocReport(RepSelect, Rec);
                end;
            }
        }
    }

    local procedure TemplateCodeOnAfterValidate()
    begin
        CurrPage.UPDATE;
    end;
}

