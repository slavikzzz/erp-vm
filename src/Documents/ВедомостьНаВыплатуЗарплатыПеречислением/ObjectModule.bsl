#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
	ВедомостьНаВыплатуЗарплаты.ОбработкаПроверкиЗаполнения(ЭтотОбъект, Отказ, ПроверяемыеРеквизиты)	
КонецПроцедуры

Процедура ПередЗаписью(Отказ, РежимЗаписи, РежимПроведения)
	
	Если ЗарплатаКадры.ОтключитьБизнесЛогикуПриЗаписи(ЭтотОбъект) Тогда
		Возврат;
	КонецЕсли;
	
	ВедомостьНаВыплатуЗарплаты.ПередЗаписью(ЭтотОбъект, Отказ, РежимЗаписи);
	
КонецПроцедуры

Процедура ОбработкаПроведения(Отказ, РежимПроведения)
	ВедомостьНаВыплатуЗарплаты.ОбработкаПроведения(ЭтотОбъект, Отказ);
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

#Область СценарииЗаполненияДокумента

Функция МожноЗаполнитьЗарплату() Экспорт
	Возврат ВедомостьНаВыплатуЗарплаты.МожноЗаполнитьЗарплату(ЭтотОбъект)
КонецФункции

#КонецОбласти

#Область МестоВыплаты

Функция МестоВыплаты() Экспорт
	МестоВыплаты = ВедомостьНаВыплатуЗарплаты.МестоВыплаты();
	МестоВыплаты.Вид      = Перечисления.ВидыМестВыплатыЗарплаты.БанковскийСчет;
	МестоВыплаты.Значение = Банк;
	Возврат МестоВыплаты
КонецФункции

Процедура УстановитьМестоВыплаты(Значение) Экспорт
	Банк = Значение
КонецПроцедуры

#КонецОбласти

#Область ЗаполнениеДокумента

Процедура ОчиститьВыплаты() Экспорт
	ВедомостьНаВыплатуЗарплаты.ОчиститьВыплаты(ЭтотОбъект);
КонецПроцедуры	

Процедура ЗагрузитьВыплаты(Зарплата, НДФЛ) Экспорт
	ДополнитьТаблицуЗарплатБанковскимиСчетамиСотрудников(Зарплата);
	ВедомостьНаВыплатуЗарплаты.ЗагрузитьВыплаты(ЭтотОбъект, Зарплата, НДФЛ, "ФизическоеЛицо, БанковскийСчет");
	ВедомостьНаВыплатуЗарплаты.УстановитьВзыскания(ЭтотОбъект, Зарплата);
КонецПроцедуры

Процедура ДобавитьВыплаты(Зарплата, НДФЛ) Экспорт
	ДополнитьТаблицуЗарплатБанковскимиСчетамиСотрудников(Зарплата);
	ВедомостьНаВыплатуЗарплаты.ДобавитьВыплаты(ЭтотОбъект, Зарплата, НДФЛ, "ФизическоеЛицо, БанковскийСчет");
	ВедомостьНаВыплатуЗарплаты.УстановитьВзыскания(ЭтотОбъект, Зарплата);
КонецПроцедуры

Процедура УстановитьНДФЛ(НДФЛ, Знач ФизическиеЛица = Неопределено) Экспорт
	ВедомостьНаВыплатуЗарплаты.УстановитьНДФЛ(ЭтотОбъект, НДФЛ, ФизическиеЛица)
КонецПроцедуры

Процедура ДополнитьТаблицуЗарплатБанковскимиСчетамиСотрудников(ТаблицаЗарплат)
	
	МетаданныеРеквизита = Метаданные().ТабличныеЧасти.Состав.Реквизиты.БанковскийСчет;
	ТаблицаЗарплат.Колонки.Добавить(МетаданныеРеквизита.Имя, МетаданныеРеквизита.Тип);
	ЕстьКолонкаМестоВыплаты = (ТаблицаЗарплат.Колонки.Найти("МестоВыплаты") <> Неопределено);
	
	БанковскиеСчетаСотрудников = 
		Документы.ВедомостьНаВыплатуЗарплатыПеречислением.БанковскиеСчетаСотрудников(ТаблицаЗарплат.ВыгрузитьКолонку("Сотрудник"), Банк, СпособВыплаты);
		
	Для Каждого СтрокаЗарплаты Из ТаблицаЗарплат Цикл
		Если НЕ ЗначениеЗаполнено(СтрокаЗарплаты.БанковскийСчет) Тогда
			Если ЕстьКолонкаМестоВыплаты
				И ТипЗнч(СтрокаЗарплаты.МестоВыплаты) = Тип("СправочникСсылка.БанковскиеСчетаКонтрагентов")
				И ЗначениеЗаполнено(СтрокаЗарплаты.МестоВыплаты) Тогда
				СтрокаЗарплаты.БанковскийСчет = СтрокаЗарплаты.МестоВыплаты;
				Продолжить;
			КонецЕсли;
			БанковскийСчетСотрудника = БанковскиеСчетаСотрудников[СтрокаЗарплаты.Сотрудник];
			Если БанковскийСчетСотрудника = Неопределено Тогда
				СтрокаЗарплаты.БанковскийСчет = Справочники.БанковскиеСчетаКонтрагентов.ПустаяСсылка();
			Иначе	
				СтрокаЗарплаты.БанковскийСчет = БанковскийСчетСотрудника;
			КонецЕсли	
		КонецЕсли	
	КонецЦикла
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти

#Иначе
ВызватьИсключение НСтр("ru = 'Недопустимый вызов объекта на клиенте.';
						|en = 'Invalid object call on the client.'");
#КонецЕсли