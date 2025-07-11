#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
	// Удаление непроверяемых реквизитов.
	НепроверяемыеРеквизиты = Новый Массив;
	Если Не РегламентированнаяОтчетностьВызовСервера.ЭтоЮридическоеЛицо(Организация) Тогда
		НепроверяемыеРеквизиты.Добавить("КПП");
	КонецЕсли;
	ОбщегоНазначения.УдалитьНепроверяемыеРеквизитыИзМассива(ПроверяемыеРеквизиты, НепроверяемыеРеквизиты);
	
	// Отсутствие дублей в табличной части.
	Количество = Пособия.Количество();
	Если Количество > 1 Тогда
		ТаблицаПроверки = Пособия.Выгрузить(, "НомерСтроки, ФизическоеЛицо, ДатаСтраховогоСлучая");
		ТаблицаПроверки.Сортировать("ФизическоеЛицо, ДатаСтраховогоСлучая, НомерСтроки");
		ПредшествующаяСтрока = ТаблицаПроверки[0];
		Для ИндексСтроки = 1 По Количество - 1 Цикл
			СтрокаТаблицы = ТаблицаПроверки[ИндексСтроки];
			Если ЗначениеЗаполнено(СтрокаТаблицы.ФизическоеЛицо)
				И СтрокаТаблицы.ФизическоеЛицо = ПредшествующаяСтрока.ФизическоеЛицо
				И СтрокаТаблицы.ДатаСтраховогоСлучая = ПредшествующаяСтрока.ДатаСтраховогоСлучая Тогда
				Текст = СтрШаблон(
					НСтр("ru = 'Пособие %1 от %2 дублируется в строках %3 и %4.';
						|en = 'Benefit %1 from %2 is duplicated in lines %3 and %4.'"),
					СтрокаТаблицы.ФизическоеЛицо,
					СтрокаТаблицы.ДатаСтраховогоСлучая,
					ПредшествующаяСтрока.НомерСтроки,
					СтрокаТаблицы.НомерСтроки);
				ИмяРеквизита = "ДатаСтраховогоСлучая";
				СообщенияБЗК.СообщитьОбОшибкеВСтрокеТаблицы(Отказ, ЭтотОбъект, "Пособия", СтрокаТаблицы, ИмяРеквизита, Текст);
			КонецЕсли;
			ПредшествующаяСтрока = СтрокаТаблицы;
		КонецЦикла;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

#Область ФиксацияВторичныхДанныхВДокументах

Функция ОбъектЗафиксирован() Экспорт
	Возврат Не ПрямыеВыплатыПособийСоциальногоСтрахования.СтатусПозволяетРедактироватьДокумент(СтатусДокумента);
КонецФункции

Функция ОбновитьВторичныеДанныеДокумента() Экспорт
	Если ОбъектЗафиксирован() Тогда
		Возврат Ложь;
	КонецЕсли;
	
	Менеджер = ОбщегоНазначения.МенеджерОбъектаПоПолномуИмени(Метаданные().ПолноеИмя());
	ПараметрыФиксации = Менеджер.ПараметрыФиксацииВторичныхДанных();
	Модифицирован = Ложь;
	
	Если ОбновитьДанныеОрганизации(ПараметрыФиксации) Тогда
		Модифицирован = Истина;
	КонецЕсли;
	Если ЗаполнитьСведенияОПредставителеСФР(ПараметрыФиксации) Тогда
		Модифицирован = Истина;
	КонецЕсли;
	Если ОбновитьДанныеБольничных(ПараметрыФиксации) Тогда
		Модифицирован = Истина;
	КонецЕсли;
	Если ОбновитьСуммыПособий(ПараметрыФиксации) Тогда
		Модифицирован = Истина;
	КонецЕсли;
	Если ОбновитьДанныеФизическихЛиц(ПараметрыФиксации) Тогда
		Модифицирован = Истина;
	КонецЕсли;
	
	Возврат Модифицирован;
КонецФункции

Функция ОбновитьДанныеОрганизации(ПараметрыФиксации)
	Если Не ЗначениеЗаполнено(Организация) Тогда
		Возврат Ложь;
	КонецЕсли;
	
	РеквизитыДокумента = Новый Структура(
		"РегистрационныйНомерФСС,ДополнительныйКодФСС,КодПодчиненностиФСС,НаименованиеТерриториальногоОрганаФСС,ИНН,КПП,
		|ПредставительСФР,ДолжностьПредставителяСФР,ОснованиеПодписиПредставителяСФР,АдресОрганизации,
		|Банк,НаименованиеБанка,НомерЛицевогоСчета,НомерСчета,БИКБанка");
	
	СведенияОПодписях = ПодписиДокументов.СведенияОПодписяхПоУмолчаниюДляОбъектаМетаданных(Метаданные(), Организация);
	ЗаполнитьЗначенияСвойств(РеквизитыДокумента, СведенияОПодписях);
	
	ИменаПолей =
	"РегистрационныйНомерФСС,
	|КодПодчиненностиФСС,
	|ДополнительныйКодФСС,
	|НаименованиеТерриториальногоОрганаФСС,
	|ИННЮЛ,
	|КППЮЛ,
	|БанкСчетНомер,
	|БанкСчетНаимБанка,
	|БанкСчетБИКБанка,
	|АдрЮР_JSON,
	|ТелОрганизации_JSON,
	|АдресЭлектроннойПочтыОрганизации";
	СведенияОСтрахователе = СЭДОФСС.СведенияОСтрахователе(Организация, ИменаПолей, Дата);
	ЗаполнитьЗначенияСвойств(РеквизитыДокумента, СведенияОСтрахователе);
	
	РеквизитыДокумента.ИНН                = СведенияОСтрахователе.ИННЮЛ;
	РеквизитыДокумента.КПП                = СведенияОСтрахователе.КППЮЛ;
	РеквизитыДокумента.НомерСчета         = СведенияОСтрахователе.БанкСчетНомер;
	РеквизитыДокумента.НаименованиеБанка  = СведенияОСтрахователе.БанкСчетНаимБанка;
	РеквизитыДокумента.БИКБанка           = СведенияОСтрахователе.БанкСчетБИКБанка;
	РеквизитыДокумента.АдресОрганизации   = СведенияОСтрахователе.АдрЮР_JSON;
	ДополнительныеСвойства.Вставить("СведенияОСтрахователе", СведенияОСтрахователе);
	
	Возврат ФиксацияВторичныхДанныхВДокументах.ОбновитьДанныеШапки(РеквизитыДокумента, ЭтотОбъект, ПараметрыФиксации, Истина);
КонецФункции

Функция ЗаполнитьСведенияОПредставителеСФР(ПараметрыФиксации)
	Реквизиты = Новый Структура("ТелефонСоставителя, АдресЭлектроннойПочтыОрганизации");
	Если ДополнительныеСвойства.Свойство("СведенияОСтрахователе") Тогда
		Реквизиты.ТелефонСоставителя = ДополнительныеСвойства.СведенияОСтрахователе.ТелОрганизации_JSON;
		Реквизиты.АдресЭлектроннойПочтыОрганизации = ДополнительныеСвойства.СведенияОСтрахователе.АдресЭлектроннойПочтыОрганизации;
	КонецЕсли;
	Если ЗначениеЗаполнено(ПредставительСФР) Тогда
		ИменаПолей = "ТелефонРабочий, EMailПредставление";
		КадровыеДанные = КадровыйУчет.КадровыеДанныеФизическогоЛица(Ложь, ПредставительСФР, ИменаПолей, ТекущаяДатаСеанса());
		Если КадровыеДанные <> Неопределено Тогда
			Если ЗначениеЗаполнено(КадровыеДанные.ТелефонРабочий) Тогда
				Реквизиты.ТелефонСоставителя = КадровыеДанные.ТелефонРабочий;
			КонецЕсли;
			Если ЗначениеЗаполнено(КадровыеДанные.EMailПредставление) Тогда
				Реквизиты.АдресЭлектроннойПочтыОрганизации = КадровыеДанные.EMailПредставление;
			КонецЕсли;
		КонецЕсли;
	КонецЕсли;
	Возврат ФиксацияВторичныхДанныхВДокументах.ОбновитьДанныеШапки(Реквизиты, ЭтотОбъект, ПараметрыФиксации, Истина);
КонецФункции

Функция ОбновитьДанныеБольничных(ПараметрыФиксации)
	Больничные = Пособия.ВыгрузитьКолонку("Больничный");
	ОбратныйИндекс = Больничные.Количество();
	Пока ОбратныйИндекс > 0 Цикл
		ОбратныйИндекс = ОбратныйИндекс - 1;
		Если Не ЗначениеЗаполнено(Больничные[ОбратныйИндекс]) Тогда
			Больничные.Удалить(ОбратныйИндекс);
		КонецЕсли;
	КонецЦикла;
	Если Больничные.Количество() = 0 Тогда
		Возврат Ложь;
	КонецЕсли;
	
	Реквизиты = "ФизическоеЛицо, ДатаНачалаСобытия, ДатаНачала, ДатаОкончания";
	ЗначенияРеквизитов = ОбщегоНазначения.ЗначенияРеквизитовОбъектов(Больничные, Реквизиты, Истина);
	НовыеЗначения = Новый Структура("ФизическоеЛицо, ДатаСтраховогоСлучая, ДатаНачала, ДатаОкончания");
	ОбъектМодифицирован = Ложь;
	Для Каждого КлючИЗначение Из ЗначенияРеквизитов Цикл
		ЗаполнитьЗначенияСвойств(НовыеЗначения, КлючИЗначение.Значение);
		НовыеЗначения.ДатаСтраховогоСлучая = КлючИЗначение.Значение.ДатаНачалаСобытия;
		Найденные = Пособия.НайтиСтроки(Новый Структура("Больничный", КлючИЗначение.Ключ));
		Для Каждого СтрокаПособия Из Найденные Цикл
			Если ФиксацияВторичныхДанныхВДокументах.ОбновитьДанныеСтроки(
				НовыеЗначения,
				ЭтотОбъект,
				"Пособия",
				СтрокаПособия,
				ПараметрыФиксации) Тогда
				ОбъектМодифицирован = Истина;
			КонецЕсли;
		КонецЦикла;
	КонецЦикла;
	Возврат ОбъектМодифицирован;
КонецФункции

Функция ОбновитьСуммыПособий(ПараметрыФиксации)
	Больничные = Пособия.ВыгрузитьКолонку("Больничный");
	ОбратныйИндекс = Больничные.Количество();
	Пока ОбратныйИндекс > 0 Цикл
		ОбратныйИндекс = ОбратныйИндекс - 1;
		Если Не ЗначениеЗаполнено(Больничные[ОбратныйИндекс]) Тогда
			Больничные.Удалить(ОбратныйИндекс);
		КонецЕсли;
	КонецЦикла;
	Если Больничные.Количество() = 0 Тогда
		Возврат Ложь;
	КонецЕсли;
	
	МенеджерВТ = Новый МенеджерВременныхТаблиц;
	СоздатьВТСуммыКВозмещению(МенеджерВТ, Истина);
	СуммыКВозмещению    = МенеджерВТ.Таблицы["ВТСуммыКВозмещению"].ПолучитьДанные().Выгрузить();
	НовыеЗначения       = Новый Структура("СуммаСверхНорм, СуммаФинансируемаяРаботодателем");
	Фильтр              = Новый Структура("ДатаСтраховогоСлучая, ФизическоеЛицо");
	ОбъектМодифицирован = Ложь;
	Для Каждого СтрокаСумм Из СуммыКВозмещению Цикл
		ЗаполнитьЗначенияСвойств(НовыеЗначения, СтрокаСумм);
		ЗаполнитьЗначенияСвойств(Фильтр, СтрокаСумм);
		Найденные = Пособия.НайтиСтроки(Фильтр);
		Для Каждого СтрокаПособия Из Найденные Цикл
			Если ФиксацияВторичныхДанныхВДокументах.ОбновитьДанныеСтроки(
				НовыеЗначения,
				ЭтотОбъект,
				"Пособия",
				СтрокаПособия,
				ПараметрыФиксации) Тогда
				ОбъектМодифицирован = Истина;
			КонецЕсли;
		КонецЦикла;
	КонецЦикла;
	Возврат ОбъектМодифицирован;
КонецФункции

Функция ОбновитьДанныеФизическихЛиц(ПараметрыФиксации)
	МассивФизлиц = Пособия.ВыгрузитьКолонку("ФизическоеЛицо");
	ОбратныйИндекс = МассивФизлиц.Количество();
	Пока ОбратныйИндекс > 0 Цикл
		ОбратныйИндекс = ОбратныйИндекс - 1;
		Если Не ЗначениеЗаполнено(МассивФизлиц[ОбратныйИндекс]) Тогда
			МассивФизлиц.Удалить(ОбратныйИндекс);
		КонецЕсли;
	КонецЦикла;
	Если МассивФизлиц.Количество() = 0 Тогда
		Возврат Ложь;
	КонецЕсли;
	
	ТолькоРазрешенные = Истина;
	ИменаПолей = "Фамилия,Имя,Отчество,СтраховойНомерПФР";
	КадровыеДанные = КадровыйУчет.КадровыеДанныеФизическихЛиц(ТолькоРазрешенные, МассивФизлиц, ИменаПолей, Дата);
	
	ОбъектМодифицирован = Ложь;
	НовыеЗначения = Новый Структура("Фамилия, Имя, Отчество, СНИЛС");
	Для Каждого СтрокаТаблицы Из КадровыеДанные Цикл
		ЗаполнитьЗначенияСвойств(НовыеЗначения, СтрокаТаблицы);
		НовыеЗначения.СНИЛС = СтрокаТаблицы.СтраховойНомерПФР;
		Найденные = Пособия.НайтиСтроки(Новый Структура("ФизическоеЛицо", СтрокаТаблицы.ФизическоеЛицо));
		Для Каждого СтрокаПособия Из Найденные Цикл
			Если ФиксацияВторичныхДанныхВДокументах.ОбновитьДанныеСтроки(
				НовыеЗначения,
				ЭтотОбъект,
				"Пособия",
				СтрокаПособия,
				ПараметрыФиксации) Тогда
				ОбъектМодифицирован = Истина;
			КонецЕсли;
		КонецЦикла;
	КонецЦикла;
	
	Возврат ОбъектМодифицирован;
КонецФункции

#КонецОбласти

#Область Заполнить

Процедура ЗаполнитьДокумент() Экспорт
	Пособия.Очистить();
	
	МенеджерВТ = Новый МенеджерВременныхТаблиц;
	СоздатьВТСуммыКВозмещению(МенеджерВТ, Ложь);
	
	Запрос = Новый Запрос;
	Запрос.МенеджерВременныхТаблиц = МенеджерВТ;
	Запрос.Текст =
	"ВЫБРАТЬ
	|	ВТСуммыКВозмещению.Больничный КАК Больничный,
	|	ВТСуммыКВозмещению.ДатаСтраховогоСлучая КАК ДатаСтраховогоСлучая,
	|	ВТСуммыКВозмещению.ФизическоеЛицо КАК ФизическоеЛицо,
	|	ВТСуммыКВозмещению.СуммаСверхНорм КАК СуммаСверхНорм,
	|	ВТСуммыКВозмещению.СуммаФинансируемаяРаботодателем КАК СуммаФинансируемаяРаботодателем
	|ИЗ
	|	ВТСуммыКВозмещению КАК ВТСуммыКВозмещению
	|ГДЕ
	|	ВТСуммыКВозмещению.СуммаСверхНорм > 0";
	
	СуммыКВозмещению = Запрос.Выполнить().Выгрузить();
	Для Каждого СтрокаСумм Из СуммыКВозмещению Цикл
		ЗаполнитьЗначенияСвойств(Пособия.Добавить(), СтрокаСумм);
	КонецЦикла;
КонецПроцедуры

Процедура СоздатьВТСуммыКВозмещению(МенеджерВТ, ФильтроватьПоИспользуемым)
	Запрос = Новый Запрос;
	Запрос.МенеджерВременныхТаблиц = МенеджерВТ;
	
	Если ФильтроватьПоИспользуемым Тогда
		Запрос.Текст =
		"ВЫБРАТЬ
		|	Пособия.ФизическоеЛицо КАК ФизическоеЛицо,
		|	Пособия.ДатаСтраховогоСлучая КАК ДатаСтраховогоСлучая,
		|	Пособия.Больничный КАК Больничный
		|ПОМЕСТИТЬ ВТПособия
		|ИЗ
		|	&Пособия КАК Пособия
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	Таблица.ФизическоеЛицо КАК ФизическоеЛицо,
		|	Таблица.ДатаСтраховогоСлучая КАК ДатаСтраховогоСлучая,
		|	МАКСИМУМ(Таблица.Больничный) КАК Больничный
		|ПОМЕСТИТЬ ВТСтраховыеСлучаи
		|ИЗ
		|	ВТПособия КАК Таблица
		|
		|СГРУППИРОВАТЬ ПО
		|	Таблица.ФизическоеЛицо,
		|	Таблица.ДатаСтраховогоСлучая";
		Запрос.УстановитьПараметр("Пособия", Пособия.Выгрузить(, "ФизическоеЛицо, ДатаСтраховогоСлучая, Больничный"));
	Иначе
		Запрос.Текст = 
		"ВЫБРАТЬ
		|	Регистр.ФизическоеЛицо КАК ФизическоеЛицо,
		|	Регистр.ДатаСтраховогоСлучая КАК ДатаСтраховогоСлучая,
		|	МАКСИМУМ(Регистр.Регистратор) КАК Больничный
		|ПОМЕСТИТЬ ВТСтраховыеСлучаи
		|ИЗ
		|	РегистрНакопления.ПособияПоСоциальномуСтрахованию КАК Регистр
		|ГДЕ
		|	Регистр.Период МЕЖДУ &НачалоПериода И &ОкончаниеПериода
		|	И Регистр.СуммаСверхНорм <> 0
		|	И Регистр.Организация = &Организация
		|	И Регистр.ВидПособияСоциальногоСтрахования = &Нетрудоспособность
		|
		|СГРУППИРОВАТЬ ПО
		|	Регистр.ФизическоеЛицо,
		|	Регистр.ДатаСтраховогоСлучая";
		Запрос.УстановитьПараметр("НачалоПериода", НачалоКвартала(ДобавитьМесяц(Дата, -6)));
		Запрос.УстановитьПараметр("ОкончаниеПериода", КонецДня(Дата));
		Запрос.УстановитьПараметр("Нетрудоспособность", Перечисления.ПереченьПособийСоциальногоСтрахования.Нетрудоспособность);
	КонецЕсли;
	
	Запрос.Текст = Запрос.Текст + ЗарплатаКадрыОбщиеНаборыДанных.РазделительЗапросов() +
	"ВЫБРАТЬ
	|	ВТСтраховыеСлучаи.ФизическоеЛицо КАК ФизическоеЛицо,
	|	ВТСтраховыеСлучаи.ДатаСтраховогоСлучая КАК ДатаСтраховогоСлучая,
	|	ВТСтраховыеСлучаи.Больничный КАК Больничный,
	|	СУММА(ПособияПоСоциальномуСтрахованию.СуммаСверхНорм) КАК СуммаСверхНорм,
	|	СУММА(ПособияПоСоциальномуСтрахованию.СуммаФинансируемаяРаботодателем) КАК СуммаФинансируемаяРаботодателем
	|ПОМЕСТИТЬ ВТИзвестныеОснования
	|ИЗ
	|	ВТСтраховыеСлучаи КАК ВТСтраховыеСлучаи
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрНакопления.ПособияПоСоциальномуСтрахованию КАК ПособияПоСоциальномуСтрахованию
	|		ПО ВТСтраховыеСлучаи.ФизическоеЛицо = ПособияПоСоциальномуСтрахованию.ФизическоеЛицо
	|			И ВТСтраховыеСлучаи.ДатаСтраховогоСлучая = ПособияПоСоциальномуСтрахованию.ДатаСтраховогоСлучая
	|			И (ПособияПоСоциальномуСтрахованию.Организация = &Организация)
	|
	|СГРУППИРОВАТЬ ПО
	|	ВТСтраховыеСлучаи.ФизическоеЛицо,
	|	ВТСтраховыеСлучаи.ДатаСтраховогоСлучая,
	|	ВТСтраховыеСлучаи.Больничный
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ВложенныйЗапрос.Больничный КАК Больничный,
	|	ВложенныйЗапрос.ДатаСтраховогоСлучая КАК ДатаСтраховогоСлучая,
	|	ВложенныйЗапрос.ФизическоеЛицо КАК ФизическоеЛицо,
	|	СУММА(ВложенныйЗапрос.СуммаСверхНорм) КАК СуммаСверхНорм,
	|	СУММА(ВложенныйЗапрос.СуммаФинансируемаяРаботодателем) КАК СуммаФинансируемаяРаботодателем
	|ПОМЕСТИТЬ ВТСуммыКВозмещению
	|ИЗ
	|	(ВЫБРАТЬ
	|		ВТИзвестныеОснования.Больничный КАК Больничный,
	|		ВТИзвестныеОснования.ДатаСтраховогоСлучая КАК ДатаСтраховогоСлучая,
	|		ВТИзвестныеОснования.ФизическоеЛицо КАК ФизическоеЛицо,
	|		ВТИзвестныеОснования.СуммаСверхНорм КАК СуммаСверхНорм,
	|		ВТИзвестныеОснования.СуммаФинансируемаяРаботодателем КАК СуммаФинансируемаяРаботодателем
	|	ИЗ
	|		ВТИзвестныеОснования КАК ВТИзвестныеОснования
	|	
	|	ОБЪЕДИНИТЬ ВСЕ
	|	
	|	ВЫБРАТЬ
	|		ВТИзвестныеОснования.Больничный,
	|		ВТИзвестныеОснования.ДатаСтраховогоСлучая,
	|		ВТИзвестныеОснования.ФизическоеЛицо,
	|		-ТЧПособия.СуммаСверхНорм,
	|		-ТЧПособия.СуммаФинансируемаяРаботодателем
	|	ИЗ
	|		ВТИзвестныеОснования КАК ВТИзвестныеОснования
	|			ВНУТРЕННЕЕ СОЕДИНЕНИЕ Документ.ВозмещениеБольничныхВЧастиФБ.Пособия КАК ТЧПособия
	|			ПО ВТИзвестныеОснования.ДатаСтраховогоСлучая = ТЧПособия.ДатаСтраховогоСлучая
	|				И ВТИзвестныеОснования.ФизическоеЛицо = ТЧПособия.ФизическоеЛицо
	|				И (ТЧПособия.Ссылка <> &Ссылка)
	|			ВНУТРЕННЕЕ СОЕДИНЕНИЕ Документ.ВозмещениеБольничныхВЧастиФБ КАК ВозмещениеБольничныхВЧастиФБ
	|			ПО (ТЧПособия.Ссылка = ВозмещениеБольничныхВЧастиФБ.Ссылка)
	|				И (ВозмещениеБольничныхВЧастиФБ.Проведен)) КАК ВложенныйЗапрос
	|
	|СГРУППИРОВАТЬ ПО
	|	ВложенныйЗапрос.Больничный,
	|	ВложенныйЗапрос.ДатаСтраховогоСлучая,
	|	ВложенныйЗапрос.ФизическоеЛицо";
	Запрос.УстановитьПараметр("Организация", Организация);
	Запрос.УстановитьПараметр("Ссылка", Ссылка);
	Запрос.Выполнить();
КонецПроцедуры

#КонецОбласти

#КонецОбласти

#Иначе
ВызватьИсключение НСтр("ru = 'Недопустимый вызов объекта на клиенте.';
						|en = 'Invalid object call on the client.'");
#КонецЕсли