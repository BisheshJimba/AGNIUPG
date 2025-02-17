page 50015 "QR Dynamic List"
{
    PageType = List;
    SourceTable = Table33019974;
    SourceTableTemporary = true;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Package No."; "Code 1")
                {
                    Visible = PackageColumnVisible;
                }
                field("Item No."; "Code 1")
                {
                    Visible = ItemColumnVisible;
                }
            }
        }
    }

    actions
    {
    }

    var
        [InDataSet]
        ItemColumnVisible: Boolean;
        [InDataSet]
        PackageColumnVisible: Boolean;

    [Scope('Internal')]
    procedure InitPackage(ReceiptNo: Code[20])
    var
        QRMgt: Codeunit "50006";
    begin
        QRMgt.InsertPackageNo(ReceiptNo, Rec);
        RESET;
        IF FINDFIRST THEN;
    end;

    [Scope('Internal')]
    procedure InitItem(ReceiptNo: Code[20]; PkgNo: Code[20])
    var
        QRMgt: Codeunit "50006";
    begin
        QRMgt.GetItemsForQRPrint(ReceiptNo, PkgNo, Rec);
        RESET;
        IF FINDFIRST THEN;
    end;

    [Scope('Internal')]
    procedure DisplayItem()
    begin
        ItemColumnVisible := TRUE;
    end;

    [Scope('Internal')]
    procedure DisplayPackage()
    begin
        PackageColumnVisible := TRUE;
    end;
}

