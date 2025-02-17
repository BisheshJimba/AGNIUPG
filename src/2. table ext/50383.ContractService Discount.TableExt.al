tableextension 50383 tableextension50383 extends "Contract/Service Discount"
{
    fields
    {
        modify("Contract No.")
        {
            TableRelation = IF (Contract Type=CONST(Template)) "Service Contract Template".No.
                            ELSE IF (Contract Type=CONST(Contract)) "Service Contract Header"."Contract No." WHERE (Contract Type=CONST(Contract))
                            ELSE IF (Contract Type=CONST(Quote)) "Service Contract Header"."Contract No." WHERE (Contract Type=CONST(Quote));
        }
        modify("No.")
        {
            TableRelation = IF (Type = CONST(Service Item Group)) "Service Item Group".Code
                            ELSE IF (Type=CONST(Resource Group)) "Resource Group".No.
                            ELSE IF (Type=CONST(Cost)) "Service Cost".Code;
        }
    }
}

