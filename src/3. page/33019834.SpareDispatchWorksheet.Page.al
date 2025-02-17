page 33019834 "Spare Dispatch Worksheet"
{
    AutoSplitKey = true;
    InsertAllowed = false;
    ModifyAllowed = false;
    MultipleNewLines = true;
    PageType = List;
    SourceTable = Table33019833;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Vendor Invoice No."; "Vendor Invoice No.")
                {
                    Style = StrongAccent;
                    StyleExpr = InvalidEntry;
                }
                field("Item No."; "Item No.")
                {
                    Style = StrongAccent;
                    StyleExpr = InvalidEntry;
                }
                field("Received Qty."; "Received Qty.")
                {
                    Style = StrongAccent;
                    StyleExpr = InvalidEntry;
                }
                field("Our Order No."; "Our Order No.")
                {
                    Style = StrongAccent;
                    StyleExpr = InvalidEntry;
                }
                field("Vendor Order No."; "Vendor Order No.")
                {
                    Style = StrongAccent;
                    StyleExpr = InvalidEntry;
                }
                field("Purchase Price"; "Purchase Price")
                {
                }
                field("Ordered Qty."; "Ordered Qty.")
                {
                    Style = StrongAccent;
                    StyleExpr = InvalidEntry;
                }
                field("Outstanding Qty."; "Outstanding Qty.")
                {
                    Style = StrongAccent;
                    StyleExpr = InvalidEntry;
                }
                field(Status; Status)
                {
                    Style = StrongAccent;
                    StyleExpr = InvalidEntry;

                    trigger OnValidate()
                    begin
                        IF Status = Status::"Not Found" THEN
                            InvalidEntry := TRUE;
                    end;
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
            group("F&unctions")
            {
                Caption = 'F&unctions';
                action("<Action1102159019>")
                {
                    Caption = '&Import Dispatch';
                    Image = Import;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;

                    trigger OnAction()
                    var
                        CurrFile: File;
                        CurrStream: InStream;
                        ClientFileName: Text[1024];
                        SelectDispatchFile: Label 'Select the Dispatch File.';
                    begin
                        BEGIN
                            IF ISSERVICETIER THEN BEGIN
                                IF NOT UPLOADINTOSTREAM(
                                                  SelectDispatchFile,
                                                   'C:\',
                                                   'XML File *.csv| *.csv',
                                                    ClientFileName,
                                                    CurrStream) THEN
                                    EXIT;
                            END
                            ELSE BEGIN
                                CurrFile.OPEN('C:\');
                                CurrFile.CREATEINSTREAM(CurrStream);
                            END;
                            XMLPORT.IMPORT(50004, CurrStream);
                            IF NOT ISSERVICETIER THEN CurrFile.CLOSE;
                        END;
                    end;
                }
            }
        }
        area(navigation)
        {
            action("<Action1102159014>")
            {
                Caption = '&Navigate Purchase Order';
                Image = Navigate;
                InFooterBar = false;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                RunObject = Page 50;
                RunPageLink = No.=FIELD(Our Order No.);
            }
        }
    }

    trigger OnAfterGetRecord()
    begin
        IF Status = Status::"Not Found" THEN
          InvalidEntry := TRUE
        ELSE
          InvalidEntry := FALSE;
    end;

    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        IF Status = Status::"Not Found" THEN
          InvalidEntry := TRUE
        ELSE
          InvalidEntry := FALSE;
    end;

    var
        [InDataSet]
        InvalidEntry: Boolean;
}

