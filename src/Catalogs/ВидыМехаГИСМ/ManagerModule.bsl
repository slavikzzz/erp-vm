#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

// Возвращает полные данные классификатора видов меха.
//
// Возвращаемое значение:
//     ТаблицаЗначений - данные классификатора с колонками:
//         * Код          - Строка - Код элемента классификатора
//         * Наименование - Строка - Наименование вида меха
//         * КодТНВЭД     - Строка - Код ТНВЭД.
//
// Таблица значений проиндексирована по полям "Код", "Наименование".
//
Функция ТаблицаКлассификатора() Экспорт
	
	Макет = ПолучитьМакет("ДанныеКлассификатора");
	
	Чтение = Новый ЧтениеXML;
	Чтение.УстановитьСтроку(Макет.ПолучитьТекст());
	
	Возврат СериализаторXDTO.ПрочитатьXML(Чтение);
	
КонецФункции

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Функция ТаблицаСоответствийВидовМехаПриПереходеНаФорматОбмена2_41() Экспорт
	
	ОписаниеТипаСтрока2 = Новый ОписаниеТипов("Строка",,Новый КвалификаторыСтроки(2, ДопустимаяДлина.Переменная));
	ОписаниеТипаСтрока150 = Новый ОписаниеТипов("Строка",,Новый КвалификаторыСтроки(150, ДопустимаяДлина.Переменная));
	
	ТаблицаСоответствий = Новый ТаблицаЗначений;
	ТаблицаСоответствий.Колонки.Добавить("КодНовый", ОписаниеТипаСтрока2);
	ТаблицаСоответствий.Колонки.Добавить("НаименованиеНовый", ОписаниеТипаСтрока150);
	ТаблицаСоответствий.Колонки.Добавить("КодСтарый", ОписаниеТипаСтрока2);
	ТаблицаСоответствий.Колонки.Добавить("НаименованиеСтарый", ОписаниеТипаСтрока150);
	
	ДобавитьСтрокуВТаблицуСоответствийВидовМехаПриПереходеНаФорматОбмена2_41(ТаблицаСоответствий, "1",  НСтр("ru = 'ондатра';
																											|en = 'ондатра'"), "74", НСтр("ru = 'ондатра';
																																			|en = 'ондатра'"));
	ДобавитьСтрокуВТаблицуСоответствийВидовМехаПриПереходеНаФорматОбмена2_41(ТаблицаСоответствий, "2",  НСтр("ru = 'шкура молодого теленка до 3-х месяцев (опойка)';
																											|en = 'шкура молодого теленка до 3-х месяцев (опойка)'"), "37", НСтр("ru = 'опоек (теленок)';
																																													|en = 'опоек (теленок)'"));
	ДобавитьСтрокуВТаблицуСоответствийВидовМехаПриПереходеНаФорматОбмена2_41(ТаблицаСоответствий, "3",  НСтр("ru = 'соболь';
																											|en = 'соболь'"), "10", НСтр("ru = 'соболь';
																																			|en = 'соболь'"));
	ДобавитьСтрокуВТаблицуСоответствийВидовМехаПриПереходеНаФорматОбмена2_41(ТаблицаСоответствий, "4",  НСтр("ru = 'шиншила';
																											|en = 'шиншила'"), "77", НСтр("ru = 'шиншилла (вискача)';
																																			|en = 'шиншилла (вискача)'"));
	ДобавитьСтрокуВТаблицуСоответствийВидовМехаПриПереходеНаФорматОбмена2_41(ТаблицаСоответствий, "5",  НСтр("ru = 'бобр, бобер';
																											|en = 'бобр, бобер'"), "73", НСтр("ru = 'бобр';
																																				|en = 'бобр'"));
	ДобавитьСтрокуВТаблицуСоответствийВидовМехаПриПереходеНаФорматОбмена2_41(ТаблицаСоответствий, "6",  НСтр("ru = 'рысь';
																											|en = 'рысь'"), "19", НСтр("ru = 'рысь, рысевидная кошка';
																																		|en = 'рысь, рысевидная кошка'"));
	ДобавитьСтрокуВТаблицуСоответствийВидовМехаПриПереходеНаФорматОбмена2_41(ТаблицаСоответствий, "7",  НСтр("ru = 'козлик, козел, козленок';
																											|en = 'козлик, козел, козленок'"), "43", НСтр("ru = 'козлик';
																																							|en = 'козлик'"));
	ДобавитьСтрокуВТаблицуСоответствийВидовМехаПриПереходеНаФорматОбмена2_41(ТаблицаСоответствий, "9",  НСтр("ru = 'морской котик';
																											|en = 'морской котик'"), "61", НСтр("ru = 'морской котик';
																																				|en = 'морской котик'"));
	ДобавитьСтрокуВТаблицуСоответствийВидовМехаПриПереходеНаФорматОбмена2_41(ТаблицаСоответствий, "10", НСтр("ru = 'кенгуру';
																											|en = 'кенгуру'") , "54", НСтр("ru = 'кенгуру, валлаби';
																																			|en = 'кенгуру, валлаби'"));
	ДобавитьСтрокуВТаблицуСоответствийВидовМехаПриПереходеНаФорматОбмена2_41(ТаблицаСоответствий, "11", НСтр("ru = 'олень';
																											|en = 'олень'") , "45", НСтр("ru = 'олень';
																																			|en = 'олень'"));
	ДобавитьСтрокуВТаблицуСоответствийВидовМехаПриПереходеНаФорматОбмена2_41(ТаблицаСоответствий, "12", НСтр("ru = 'овчина';
																											|en = 'овчина'"), "08", НСтр("ru = 'овчина (любых пород)';
																																			|en = 'овчина (любых пород)'"));
	ДобавитьСтрокуВТаблицуСоответствийВидовМехаПриПереходеНаФорматОбмена2_41(ТаблицаСоответствий, "13", НСтр("ru = 'лисица';
																											|en = 'лисица'"), "03", НСтр("ru = 'лисица (в том числе красная, крестовка, корсак, серебристо-черная, черно-бурая, снежная, фенек)';
																																			|en = 'лисица (в том числе красная, крестовка, корсак, серебристо-черная, черно-бурая, снежная, фенек)'"));
	ДобавитьСтрокуВТаблицуСоответствийВидовМехаПриПереходеНаФорматОбмена2_41(ТаблицаСоответствий, "14", НСтр("ru = 'хорек';
																											|en = 'хорек'"), "72", НСтр("ru = 'хорь';
																																		|en = 'хорь'"));
	ДобавитьСтрокуВТаблицуСоответствийВидовМехаПриПереходеНаФорматОбмена2_41(ТаблицаСоответствий, "16", НСтр("ru = 'ласка';
																											|en = 'ласка'"), "17", НСтр("ru = 'ласка';
																																		|en = 'ласка'"));
	ДобавитьСтрокуВТаблицуСоответствийВидовМехаПриПереходеНаФорматОбмена2_41(ТаблицаСоответствий, "17", НСтр("ru = 'лама';
																											|en = 'лама'"), "39", НСтр("ru = 'лама, гуанако, альпака, викунья';
																																		|en = 'лама, гуанако, альпака, викунья'"));
	ДобавитьСтрокуВТаблицуСоответствийВидовМехаПриПереходеНаФорматОбмена2_41(ТаблицаСоответствий, "18", НСтр("ru = 'койот';
																											|en = 'койот'"), "32", НСтр("ru = 'койот';
																																		|en = 'койот'"));
	ДобавитьСтрокуВТаблицуСоответствийВидовМехаПриПереходеНаФорматОбмена2_41(ТаблицаСоответствий, "19", НСтр("ru = 'скунс';
																											|en = 'скунс'"), "80", НСтр("ru = 'скунс';
																																		|en = 'скунс'"));
	ДобавитьСтрокуВТаблицуСоответствийВидовМехаПриПереходеНаФорматОбмена2_41(ТаблицаСоответствий, "20", НСтр("ru = 'куница';
																											|en = 'куница'"), "11", НСтр("ru = 'куница';
																																			|en = 'куница'"));
	ДобавитьСтрокуВТаблицуСоответствийВидовМехаПриПереходеНаФорматОбмена2_41(ТаблицаСоответствий, "21", НСтр("ru = 'волк';
																											|en = 'волк'"), "30", НСтр("ru = 'волк';
																																		|en = 'волк'"));
	ДобавитьСтрокуВТаблицуСоответствийВидовМехаПриПереходеНаФорматОбмена2_41(ТаблицаСоответствий, "22", НСтр("ru = 'сурок';
																											|en = 'сурок'"), "65", НСтр("ru = 'сурок (тарбаган и прочие)';
																																		|en = 'сурок (тарбаган и прочие)'"));
	ДобавитьСтрокуВТаблицуСоответствийВидовМехаПриПереходеНаФорматОбмена2_41(ТаблицаСоответствий, "23", НСтр("ru = 'орилаг (кролик)';
																											|en = 'орилаг (кролик)'"), "06", НСтр("ru = 'кролик (в том числе рекс-реббит, орилаг и прочие)';
																																					|en = 'кролик (в том числе рекс-реббит, орилаг и прочие)'"));
	ДобавитьСтрокуВТаблицуСоответствийВидовМехаПриПереходеНаФорматОбмена2_41(ТаблицаСоответствий, "24", НСтр("ru = 'белка';
																											|en = 'белка'"), "63", НСтр("ru = 'белка';
																																		|en = 'белка'"));
	ДобавитьСтрокуВТаблицуСоответствийВидовМехаПриПереходеНаФорматОбмена2_41(ТаблицаСоответствий, "25", НСтр("ru = 'ягненок';
																											|en = 'ягненок'"), "09", НСтр("ru = 'каракуль, каракульча, ягненок (любых пород)';
																																			|en = 'каракуль, каракульча, ягненок (любых пород)'"));
	ДобавитьСтрокуВТаблицуСоответствийВидовМехаПриПереходеНаФорматОбмена2_41(ТаблицаСоответствий, "27", НСтр("ru = 'мех пекана';
																											|en = 'мех пекана'"), "18", НСтр("ru = 'фишер (илка, пекан)';
																																				|en = 'фишер (илка, пекан)'"));
	ДобавитьСтрокуВТаблицуСоответствийВидовМехаПриПереходеНаФорматОбмена2_41(ТаблицаСоответствий, "28", НСтр("ru = 'бычья шкура';
																											|en = 'бычья шкура'"), "36", НСтр("ru = 'КРС (крупный рогатый скот: коровы, быки, буйволы, волы и т.д)';
																																				|en = 'КРС (крупный рогатый скот: коровы, быки, буйволы, волы и т.д)'"));
	ДобавитьСтрокуВТаблицуСоответствийВидовМехаПриПереходеНаФорматОбмена2_41(ТаблицаСоответствий, "29", НСтр("ru = 'енотовидная собака';
																											|en = 'енотовидная собака'"), "07", НСтр("ru = 'енот (енот полоскун, енотовидная собака)';
																																						|en = 'енот (енот полоскун, енотовидная собака)'"));
	ДобавитьСтрокуВТаблицуСоответствийВидовМехаПриПереходеНаФорматОбмена2_41(ТаблицаСоответствий, "32", НСтр("ru = 'каракуль';
																											|en = 'каракуль'"), "09", НСтр("ru = 'каракуль, каракульча, ягненок (любых пород)';
																																			|en = 'каракуль, каракульча, ягненок (любых пород)'"));
	ДобавитьСтрокуВТаблицуСоответствийВидовМехаПриПереходеНаФорматОбмена2_41(ТаблицаСоответствий, "33", НСтр("ru = 'опоссум';
																											|en = 'опоссум'"), "79", НСтр("ru = 'опоссум';
																																			|en = 'опоссум'"));
	ДобавитьСтрокуВТаблицуСоответствийВидовМехаПриПереходеНаФорматОбмена2_41(ТаблицаСоответствий, "34", НСтр("ru = 'альпака';
																											|en = 'альпака'"), "39", НСтр("ru = 'лама, гуанако, альпака, викунья';
																																			|en = 'лама, гуанако, альпака, викунья'"));
	ДобавитьСтрокуВТаблицуСоответствийВидовМехаПриПереходеНаФорматОбмена2_41(ТаблицаСоответствий, "35", НСтр("ru = 'оцелот';
																											|en = 'оцелот'"), "21", НСтр("ru = 'оцелот';
																																			|en = 'оцелот'"));
	ДобавитьСтрокуВТаблицуСоответствийВидовМехаПриПереходеНаФорматОбмена2_41(ТаблицаСоответствий, "36", НСтр("ru = 'хомяк';
																											|en = 'хомяк'"), "70", НСтр("ru = 'хомяк';
																																		|en = 'хомяк'"));
	ДобавитьСтрокуВТаблицуСоответствийВидовМехаПриПереходеНаФорматОбмена2_41(ТаблицаСоответствий, "37", НСтр("ru = 'нерпа';
																											|en = 'нерпа'"), "60", НСтр("ru = 'нерпа (тюленевые)';
																																		|en = 'нерпа (тюленевые)'"));
	ДобавитьСтрокуВТаблицуСоответствийВидовМехаПриПереходеНаФорматОбмена2_41(ТаблицаСоответствий, "38", НСтр("ru = 'мех пони';
																											|en = 'мех пони'"), "42", НСтр("ru = 'пони';
																																			|en = 'пони'"));
	ДобавитьСтрокуВТаблицуСоответствийВидовМехаПриПереходеНаФорматОбмена2_41(ТаблицаСоответствий, "39", НСтр("ru = 'мех кошки домашней';
																											|en = 'мех кошки домашней'"), "28", НСтр("ru = 'домашняя кошка';
																																						|en = 'домашняя кошка'"));
	
	Возврат ТаблицаСоответствий;
	
КонецФункции

Процедура ДобавитьСтрокуВТаблицуСоответствийВидовМехаПриПереходеНаФорматОбмена2_41(ТаблицаСоответствий, КодНовый, НаименованиеНовый, КодСтарый, НаименованиеСтарый)
	
	НоваяСтрока = ТаблицаСоответствий.Добавить();
	НоваяСтрока.КодНовый           = КодНовый;
	НоваяСтрока.НаименованиеНовый  = НаименованиеНовый;
	НоваяСтрока.КодСтарый          = КодСтарый;
	НоваяСтрока.НаименованиеСтарый = НаименованиеСтарый;
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли