#Область СлужебныеПроцедурыИФункции

Функция ВидОшибкиНедействительныйПользователь() Экспорт
	
	ВидОшибки = ОбработкаНеисправностейБЭДКлиентСервер.НовоеОписаниеВидаОшибки();
	ВидОшибки.Идентификатор = "НедействительныйПользователь";
	ВидОшибки.ЗаголовокПроблемы = НСтр("ru = 'Пользователь недействителен';
										|en = 'User is invalid'");
	ВидОшибки.ОписаниеПроблемы = НСтр("ru = 'Обработка электронных документов запрещена';
										|en = 'You cannot process electronic documents'");
	ВидОшибки.ОписаниеРешения = НСтр("ru = 'Обратитесь к администратору для настройки параметров пользователя.';
									|en = 'Contact the administrator to set up user parameters.'");
	
	Возврат ВидОшибки;
	
КонецФункции

// См. КриптографияБЭДСлужебныйКлиентСервер.РежимыПроверкиСертификата
Функция РежимыПроверкиСертификата() Экспорт
	Режимы = Новый Структура;
	Режимы.Вставить("ТолькоКвалифицированные", ЭлектроннаяПодписьСлужебныйКлиентСервер.ТолькоКвалифицированные());
	Режимы.Вставить("ПроверятьКвалифицированные", ЭлектроннаяПодписьСлужебныйКлиентСервер.ПроверятьКвалифицированные());
	Режимы.Вставить("НеПроверятьСертификат", ЭлектроннаяПодписьСлужебныйКлиентСервер.НеПроверятьСертификат());
	Возврат Режимы;
КонецФункции

#КонецОбласти