#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда
	
#Область ПрограммныйИнтерфейс

// Возвращает сериализованную в строку XML структуру для отбора строк отчета.
//
// Параметры:
//  Склад		 - СправочникСсылка.Склады	 - склад.
//  ВидОперации	 - Строка	 - вид операции.
//  Рекомендация - Строка	 - рекомендация.
// 
// Возвращаемое значение:
//  Строка - структура в виде строки XML.
//
Функция СтруктураОтборовРаспоряженийСтрокаXML(Склад, ВидОперации, Рекомендация) Экспорт
	
	Структура = Новый Структура("Склад, ВидОперации, Рекомендация", Склад, ВидОперации, Рекомендация);
	Возврат ОбщегоНазначения.ЗначениеВСтрокуXML(Структура);
	
КонецФункции

// Возвращает структуру с рекомендациями.
//
// Параметры:
//  Рекомендация - Строка	 - имя рекомендации, которой будет установлено значение Истина.
// 
// Возвращаемое значение:
//  Структура - структура со значениями полей см. ПредставленияРекомендаций.
//
Функция СтруктураРекомендаций(Рекомендация) Экспорт
	
	СтруктураРекомендаций = Новый Структура;
	Соответствие = ПредставленияРекомендаций();
	Для Каждого ЭлементСоответствия Из Соответствие Цикл
		СтруктураРекомендаций.Вставить(ЭлементСоответствия.Ключ, ЭлементСоответствия.Значение = Рекомендация);
	КонецЦикла;
	Возврат СтруктураРекомендаций;
	
КонецФункции

// Возвращает представления рекомендаций.
// 
// Возвращаемое значение:
//  Соответствие - ключ соответствия содержит имя рекомендации, значение соответствия содержит текст рекомендации.
//
Функция ПредставленияРекомендаций() Экспорт
	
	СоответствиеРекомендаций = Новый Соответствие;
	СоответствиеРекомендаций.Вставить("ЗавершитеОформлениеРасходныхОрдеровНаТовары", НСтр("ru = 'Завершите оформление расходных ордеров на товары';
																							|en = 'Create goods issues'"));
	СоответствиеРекомендаций.Вставить("ОформитеВозвратТоваровОтКлиента", НСтр("ru = 'Оформите возврат товаров от клиента';
																				|en = 'Register sales return'"));
	СоответствиеРекомендаций.Вставить("ОформитеПриходныеОрдераНаТовары", НСтр("ru = 'Оформите приходные ордера на товары';
																				|en = 'Register goods receipts'"));
	СоответствиеРекомендаций.Вставить("ОформитеПриобретениеТоваровИУслуг", НСтр("ru = 'Оформите приобретение товаров и услуг';
																				|en = 'Register vendor invoice'"));
	СоответствиеРекомендаций.Вставить("ОформитеПоступлениеТоваров", НСтр("ru = 'Оформите поступление товаров';
																		|en = 'Register goods receipt'"));
	СоответствиеРекомендаций.Вставить("ОформитеПеремещениеТоваровВСтатусеПринято", НСтр("ru = 'Оформите перемещение товаров в статусе ""Принято""';
																						|en = 'Register goods transfer in status ""Received""'"));
	СоответствиеРекомендаций.Вставить("ОформитеДокументСборкиВСтатусеСобраноРазобрано", НСтр("ru = 'Оформите документ сборки в статусе ""Собрано (разобрано)""';
																							|en = 'Register kitting document in status ""Assembled (disassembled)""'"));
	СоответствиеРекомендаций.Вставить("ОформитеДокументРазборкиВСтатусеСобраноРазобрано", НСтр("ru = 'Оформите документ разборки в статусе ""Собрано (разобрано)""';
																								|en = 'Register reverse kitting document in status ""Assembled (disassembled)""'"));
	СоответствиеРекомендаций.Вставить("ОформитеПрочееОприходованиеТоваров", НСтр("ru = 'Скорректируйте прочее оприходование товаров';
																				|en = 'Adjust other receipt of goods'"));
	СоответствиеРекомендаций.Вставить("ОформитеСкладскиеАктыДляОтраженияИзлишков", НСтр("ru = 'Оформите складские акты для отражения излишков';
																						|en = 'Register inventory adjustments to record surpluses'"));
	СоответствиеРекомендаций.Вставить("ОформитеСкладскиеАктыДляОтраженияНедостач", НСтр("ru = 'Оформите складские акты для отражения недостач';
																						|en = 'Register inventory adjustments to record shortages'"));
	СоответствиеРекомендаций.Вставить("ОформитеПередачуМатериаловВПроизводствоВСтатусеПринято", НСтр("ru = 'Оформите передачу материалов в производство в статусе ""Принято""';
																									|en = 'Register material transfer to production in status ""Received""'"));
	СоответствиеРекомендаций.Вставить("ОформитеВозвратМатериаловИзПроизводства", НСтр("ru = 'Оформите возврат материалов из производства';
																						|en = 'Register material return from production'"));
	СоответствиеРекомендаций.Вставить("ОформитеВыпускПродукции", НСтр("ru = 'Оформите выпуск продукции';
																		|en = 'Register product release'"));
	СоответствиеРекомендаций.Вставить("ОформитеВозвратСырьяОтПереработчика", НСтр("ru = 'Оформите возврат сырья от переработчика';
																					|en = 'Register ""Goods return — Subcontracting services received""'"));
	СоответствиеРекомендаций.Вставить("ОформитеПоступлениеОтПереработчика", НСтр("ru = 'Оформите поступление от переработчика';
																				|en = 'Register ""Goods receipt — External subcontracting""'"));
	СоответствиеРекомендаций.Вставить("ОформитеПоступлениеСырьяОтДавальца", НСтр("ru = 'Оформите поступление сырья от давальца';
																				|en = 'Register ""Goods receipt — Subcontracting services delivered""'"));
	СоответствиеРекомендаций.Вставить("ОформитеРасходныеОрдераНаТовары", НСтр("ru = 'Оформите расходные ордера на товары';
																				|en = 'Create goods issues'"));
	СоответствиеРекомендаций.Вставить("ОформитеРеализацииТоваровИУслуг", НСтр("ru = 'Оформите реализации товаров и услуг';
																				|en = 'Register customer invoice'"));
	СоответствиеРекомендаций.Вставить("ОформитеОтгрузкиТоваровСХранения", НСтр("ru = 'Оформите отгрузки товаров с хранения';
																				|en = 'Register VMI pick-up request from vendor'"));
	СоответствиеРекомендаций.Вставить("ОформитеПриемкиТоваровНаХранение", НСтр("ru = 'Оформите приемки товаров на хранение';
																				|en = 'Register goods receipt for storage'"));
	Возврат СоответствиеРекомендаций;
	
КонецФункции

#КонецОбласти

#КонецЕсли