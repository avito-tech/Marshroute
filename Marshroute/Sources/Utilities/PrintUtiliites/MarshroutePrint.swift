func marshroutePrint(
    _ item: Any,
    separator: String = " ",
    terminator: String = "\n")
{
    MarshroutePrintManager.print(item, separator: separator, terminator: terminator)
}

func marshrouteDebugPrint(
    _ item: Any,
    separator: String = " ",
    terminator: String = "\n")
{
    MarshroutePrintManager.debugPrint(item, separator: separator, terminator: terminator)
}
