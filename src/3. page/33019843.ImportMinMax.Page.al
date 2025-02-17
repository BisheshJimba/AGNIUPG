page 33019843 "Import Min Max"
{
    AutoSplitKey = true;
    Editable = false;
    MultipleNewLines = true;
    PageType = List;
    SourceTable = Table33019865;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Location Code"; "Location Code")
                {
                }
                field("Item No."; "Item No.")
                {
                }
                field("Variant Code"; "Variant Code")
                {
                }
                field(Description; Description)
                {
                }
                field("Reorder Point"; "Reorder Point")
                {
                }
                field("Maximum Inventory"; "Maximum Inventory")
                {
                }
                field("Replenishment System"; "Replenishment System")
                {
                }
                field("Reordering Policy"; "Reordering Policy")
                {
                }
                field("Safety Stock Quantity"; "Safety Stock Quantity")
                {
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
            group("<Action1000000014>")
            {
                Caption = 'Function';
                action("Import MinMAx")
                {
                    Caption = 'Import MinMAx';
                    Image = Import;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;

                    trigger OnAction()
                    var
                        CurrFile: File;
                        CurrStream: InStream;
                        ClientFileName: Text[1024];
                        SelectCSVFile: Label 'Select the CSV Requisition File.';
                    begin
                        BEGIN
                            IF ISSERVICETIER THEN BEGIN
                                IF NOT UPLOADINTOSTREAM(
                                                  SelectCSVFile,
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
                            XMLPORT.IMPORT(50016, CurrStream);
                            IF NOT ISSERVICETIER THEN CurrFile.CLOSE;
                        END;
                    end;
                }
            }
        }
    }
}

