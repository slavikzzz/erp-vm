#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриЧтенииНаСервере(ТекущийОбъект)

	// СтандартныеПодсистемы.УправлениеДоступом
	Если ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.УправлениеДоступом") Тогда
		МодульУправлениеДоступом = ОбщегоНазначения.ОбщийМодуль("УправлениеДоступом");
		МодульУправлениеДоступом.ПриЧтенииНаСервере(ЭтотОбъект, ТекущийОбъект);
	КонецЕсли;
	// Конец СтандартныеПодсистемы.УправлениеДоступом

КонецПроцедуры

&НаСервере
Процедура ПослеЗаписиНаСервере(ТекущийОбъект, ПараметрыЗаписи)
	
	// СтандартныеПодсистемы.УправлениеДоступом
	Если ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.УправлениеДоступом") Тогда
		МодульУправлениеДоступом = ОбщегоНазначения.ОбщийМодуль("УправлениеДоступом");
		МодульУправлениеДоступом.ПослеЗаписиНаСервере(ЭтотОбъект, ТекущийОбъект, ПараметрыЗаписи);
	КонецЕсли;
	// Конец СтандартныеПодсистемы.УправлениеДоступом
	
КонецПроцедуры

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	Объект.ВидУведомления = Перечисления.ВидыУведомленийОСпецрежимахНалогообложения.УведомлениеУменьшениеНалогаККТ;
	УведомлениеОСпецрежимахНалогообложения.НачальныеОперацииПриСозданииНаСервере(ЭтотОбъект);
	УведомлениеОСпецрежимахНалогообложения.СформироватьСпискиВыбора(ЭтотОбъект, "СпискиВыбора2024_1");
	
	Если Параметры.Свойство("Ключ") И ЗначениеЗаполнено(Объект.Ссылка) Тогда
		Если Параметры.Свойство("ДанныеПомощника") Тогда
			Параметры.ДанныеПомощника.Свойство("Организация", Объект.Организация);
			Параметры.ДанныеПомощника.Свойство("РегистрацияВИФНС", Объект.РегистрацияВИФНС);
			Если Не ЗначениеЗаполнено(Объект.РегистрацияВИФНС) Тогда 
				Объект.РегистрацияВИФНС = Документы.УведомлениеОСпецрежимахНалогообложения.РегистрацияВФНСОрганизации(Объект.Организация);
			КонецЕсли;
			СформироватьДеревоСтраниц();
			УведомлениеОСпецрежимахНалогообложения.СформироватьСтруктуруДанныхУведомленияНовогоОбразца(ЭтотОбъект);
			ЗаполнитьНачальныеДанные();
			ЗаполнитьУведомлениеДаннымиПомощника(Параметры.ДанныеПомощника);
			Модифицированность = Истина;
		Иначе
			ЗагрузитьДанные(Параметры.Ключ);
		КонецЕсли;
	ИначеЕсли Параметры.Свойство("ЗначениеКопирования") И ЗначениеЗаполнено(Параметры.ЗначениеКопирования) Тогда
		ЗагрузитьДанные(Параметры.ЗначениеКопирования);
	ИначеЕсли Параметры.Свойство("ДанныеПомощника") Тогда
		Параметры.ДанныеПомощника.Свойство("РегистрацияВИФНС", Объект.РегистрацияВИФНС);
		Если Не ЗначениеЗаполнено(Объект.РегистрацияВИФНС) Тогда 
			Объект.РегистрацияВИФНС = Документы.УведомлениеОСпецрежимахНалогообложения.РегистрацияВФНСОрганизации(Объект.Организация);
		КонецЕсли;
		СформироватьДеревоСтраниц();
		УведомлениеОСпецрежимахНалогообложения.СформироватьСтруктуруДанныхУведомленияНовогоОбразца(ЭтотОбъект);
		ЗаполнитьНачальныеДанные();
		ЗаполнитьУведомлениеДаннымиПомощника(Параметры.ДанныеПомощника);
	ИначеЕсли Параметры.Свойство("ПредставлениеXML") Тогда 
		Параметры.Свойство("РегистрацияВНалоговомОргане", Объект.РегистрацияВИФНС);
		ЗагрузитьИзXMLНаСервере(Новый Структура("Организация, РегистрацияВНалоговомОргане, ПредставлениеXML", 
								Объект.Организация, Объект.РегистрацияВИФНС, Параметры.ПредставлениеXML));
	Иначе
		Объект.РегистрацияВИФНС = Документы.УведомлениеОСпецрежимахНалогообложения.РегистрацияВФНСОрганизации(Объект.Организация);
		СформироватьДеревоСтраниц();
		УведомлениеОСпецрежимахНалогообложения.СформироватьСтруктуруДанныхУведомленияНовогоОбразца(ЭтотОбъект);
		ЗаполнитьНачальныеДанные();
	КонецЕсли;
	
	Заголовок = Заголовок + " (" + Объект.Организация + ")";
	ИдДляСвор = УведомлениеОСпецрежимахНалогообложенияСлужебный.ПолучитьИдентификаторыДляСворачивания(ЭтотОбъект);
	ЭтотОбъект["СворачиваемыеЭлементы"] = ПоместитьВоВременноеХранилище(ИдДляСвор);
	Если НЕ ОнлайнСервисыРегламентированнойОтчетностиВызовСервера.СобытиеНаступило("Отпр.увед.ум.нал.ККТ 24к1") Тогда
		Элементы.ОтправитьВКонтролирующийОрган.Видимость = Ложь;
	КонецЕсли;
	УведомлениеОСпецрежимахНалогообложения.СпрятатьКнопкиВыгрузкиОтправкиУНеактуальныхФорм(ЭтотОбъект);
КонецПроцедуры

&НаКлиенте
Процедура ПриЗакрытии(ЗавершениеРаботы)
	Если ЗавершениеРаботы Тогда
		Возврат;
	КонецЕсли;
	
	ПриЗакрытииНаСервере();
	Если Модифицированность Тогда
		Оповестить("Запись_УведомлениеОСпецрежимахНалогообложения", ПараметрыОповещенияОЗаписи(), Объект.Ссылка);
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ПередЗакрытием(Отказ, ЗавершениеРаботы, ТекстПредупреждения, СтандартнаяОбработка)
	РегламентированнаяОтчетностьКлиент.ПередЗакрытиемРегламентированногоОтчета(ЭтотОбъект, Отказ, СтандартнаяОбработка, ЗавершениеРаботы, ТекстПредупреждения);
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	УведомлениеОСпецрежимахНалогообложенияКлиент.ПриОткрытии(ЭтотОбъект, Отказ);
КонецПроцедуры

&НаКлиенте
Процедура ПослеЗаписи(ПараметрыЗаписи)
	Оповестить("Запись_УведомлениеОСпецрежимахНалогообложения", ПараметрыЗаписи, Объект.Ссылка);
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	Если ИмяСобытия = "УведомлениеОСпецрежимахНалогообложения_НавигацияПоОшибкам" Тогда 
		УведомлениеОСпецрежимахНалогообложенияКлиент.ОбработкаОповещенияНавигацииПоОшибкам(ЭтотОбъект, Параметр, Источник);
	КонецЕсли;
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ПредставлениеУведомленияПриИзмененииСодержимогоОбласти(Элемент, Область)
	УведомлениеОСпецрежимахНалогообложенияКлиент.ПриИзмененииСодержимогоОбласти(ЭтотОбъект, Область, Истина);
	
	Если Область.Имя = "ДАТА_ПОДПИСИ" Тогда
		Объект.ДатаПодписи = Область.Значение;
		УстановитьДанныеПоРегистрацииВИФНС();
	КонецЕсли;
	
	Если Область.Имя = "СумРасхККТ" Тогда 
		Область.ЦветТекста = ?(Область.Значение > 28000, Новый Цвет(255,0,0), Новый Цвет(0,0,0));
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ПредставлениеУведомленияВыбор(Элемент, Область, СтандартнаяОбработка)
	Если Область.Имя = "СобратьДанные" Тогда 
		СобратьДанные();
		СтандартнаяОбработка = Ложь;
		Возврат;
	КонецЕсли;
	
	Если УведомлениеОСпецрежимахНалогообложенияКлиент.ТиповойВыбор(ЭтотОбъект, Область, СтандартнаяОбработка) Или ЭтотОбъект["РучнойВвод"] Тогда 
		Возврат;
	КонецЕсли;
	
	Если Область.Имя = "КодНО" Тогда 
		СтандартнаяОбработка = Ложь;
		РегламентированнаяОтчетностьКлиент.ОткрытьФормуВыбораРегистрацииВИФНС(ЭтотОбъект, Область.Имя);
	КонецЕсли;
	
	Если СтандартнаяОбработка Тогда 
		УведомлениеОСпецрежимахНалогообложенияКлиент.ПредставлениеУведомленияВыбор(ЭтотОбъект, Область, СтандартнаяОбработка, Истина, Истина);
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ГиперссылкаПротоколНажатие(Элемент)
	ЭлектронныйДокументооборотСКонтролирующимиОрганамиКлиент.ОткрытьПротоколИзПанелиОтправки(ЭтотОбъект, "ФНС");
КонецПроцедуры

&НаКлиенте
Процедура ЭтапыОтправкиНажатие(Элемент)
	ЭлектронныйДокументооборотСКонтролирующимиОрганамиКлиент.ОткрытьСостояниеОтправкиИзПанелиОтправки(ЭтотОбъект, "ФНС");
КонецПроцедуры

&НаКлиенте
Процедура КритическиеОшибкиОбработкаНавигационнойСсылки(Элемент, НавигационнаяСсылкаФорматированнойСтроки, СтандартнаяОбработка)
	СтандартнаяОбработка = Ложь;
	ЭлектронныйДокументооборотСКонтролирующимиОрганамиКлиент.ОткрытьКритическиеОшибкиИзПанелиОтправки(ЭтотОбъект, "ФНС");
КонецПроцедуры

&НаКлиенте
Процедура ГиперссылкаНаименованиеЭтапаНажатие(Элемент)
	
	ПараметрыИзменения = Новый Структура;
	ПараметрыИзменения.Вставить("Форма", ЭтотОбъект);
	ПараметрыИзменения.Вставить("Организация", Объект.Организация);
	ПараметрыИзменения.Вставить("КонтролирующийОрган",
		ПредопределенноеЗначение("Перечисление.ТипыКонтролирующихОрганов.РПН"));
	ПараметрыИзменения.Вставить("ТекстВопроса", НСтр("ru = 'Вы уверены, что уведомление уже сдано?';
													|en = 'Вы уверены, что уведомление уже сдано?'"));
	
	РегламентированнаяОтчетностьКлиент.ИзменитьСтатусОтправки(ПараметрыИзменения);
	
КонецПроцедуры

&НаКлиенте
Процедура КомментарийПриИзменении(Элемент)
	Модифицированность = Истина;
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыДеревоСтраниц

&НаКлиенте
Процедура ДеревоСтраницПриАктивизацииСтроки(Элемент)
	Если УведомлениеОСпецрежимахНалогообложенияКлиент.НеобходимоФормированиеТабличногоДокумента(ЭтотОбъект, Элемент, ЭтотОбъект["УИДПереключение"]) Тогда
		ОтключитьОбработчикОжидания("ДеревоСтраницПриАктивизацииСтрокиЗавершение");
		ПодключитьОбработчикОжидания("ДеревоСтраницПриАктивизацииСтрокиЗавершение", 0.1, Истина);
	КонецЕсли;
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ПоказатьСДвухмернымШтрихкодомPDF417(Команда)
	РегламентированнаяОтчетностьКлиент.ВывестиМашиночитаемуюФормуУведомленияОСпецрежимахПоСсылке(ЭтотОбъект, Объект.Ссылка);
КонецПроцедуры

&НаКлиенте
Процедура Очистить(Команда)
	УведомлениеОСпецрежимахНалогообложенияКлиент.ОчиститьУведомление(ЭтотОбъект);
КонецПроцедуры

&НаКлиенте
Процедура Сохранить(Команда)
	СохранитьДанные();
	Оповестить("Запись_УведомлениеОСпецрежимахНалогообложения", ПараметрыОповещенияОЗаписи(), Объект.Ссылка);
КонецПроцедуры

&НаКлиенте
Процедура СформироватьXML(Команда)
	ВыгружаемыеДанные = СформироватьXMLНаСервере(УникальныйИдентификатор);
	Если ВыгружаемыеДанные <> Неопределено Тогда 
		РегламентированнаяОтчетностьКлиент.ВыгрузитьФайлы(ВыгружаемыеДанные);
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ЗаписатьИЗакрыть(Команда)
	СохранитьДанные();
	Оповестить("Запись_УведомлениеОСпецрежимахНалогообложения", ПараметрыОповещенияОЗаписи(), Объект.Ссылка);
	Закрыть(Неопределено);
КонецПроцедуры

&НаКлиенте
Процедура ОтправитьВКонтролирующийОрган(Команда)
	
	РегламентированнаяОтчетностьКлиент.ПриНажатииНаКнопкуОтправкиВКонтролирующийОрган(ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура ПроверитьВИнтернете(Команда)
	
	РегламентированнаяОтчетностьКлиент.ПроверитьВИнтернете(ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура ОбновитьОтправку(Команда)
	ЭлектронныйДокументооборотСКонтролирующимиОрганамиКлиент.ОбновитьОтправкуИзПанелиОтправки(ЭтотОбъект, "ФНС");
КонецПроцедуры

&НаКлиенте
Процедура ОтправитьНеотправленноеИзвещение(Команда)
	ЭлектронныйДокументооборотСКонтролирующимиОрганамиКлиент.ОтправитьНеотправленноеИзвещениеИзПанелиОтправки(ЭтотОбъект, "ФНС");
КонецПроцедуры

&НаКлиенте
Процедура ПроверитьВыгрузку(Команда)
	УведомлениеОСпецрежимахНалогообложенияКлиент.ПроверитьВыгрузку(ЭтотОбъект, ПроверитьВыгрузкуНаСервере());
КонецПроцедуры

&НаКлиенте
Процедура ПечатьБРО(Команда)
	ПечатьБРОНаСервере();
	РегламентированнаяОтчетностьКлиент.ОткрытьФормуПредварительногоПросмотра(
		ЭтотОбъект, "Открыть", Ложь, ЭтотОбъект["СтруктураРеквизитовУведомления"].СписокПечатаемыхЛистов);
КонецПроцедуры

&НаКлиенте
Процедура РучнойВвод(Команда)
	УведомлениеОСпецрежимахНалогообложенияКлиент.ОбработкаРучнойВвод(ЭтотОбъект);
КонецПроцедуры

&НаКлиенте
Процедура РазрешитьВыгружатьСОшибками(Команда)
	УведомлениеОСпецрежимахНалогообложенияКлиент.ОбработкаРазрешитьВыгружатьСОшибками(ЭтотОбъект);
КонецПроцедуры

&НаКлиенте
Процедура ЗагрузитьИзФайлаВФормуУведомление(Команда)
	УведомлениеОСпецрежимахНалогообложенияКлиент.ЗагрузитьИзФайлаУведомление(ЭтотОбъект);
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура ЗаполнитьУведомлениеДаннымиПомощника(ДанныеПомощника)
	ЭтотОбъект["ДанныеУведомления"].УмСумНалПрККТ.СумРасхККТ = ДанныеПомощника.Стр110;
	ЭтотОбъект["ДанныеУведомления"].УмСумНалПрККТ.СумРасхККТПревНал = ДанныеПомощника.Стр210;
	
	ДанныеЛистовА = ДанныеПомощника.ДанныеЛистовА;
	ЛистыАВДереве = ДеревоСтраниц.ПолучитьЭлементы()[1].ПолучитьЭлементы();
	Пока ЛистыАВДереве.Количество() < ДанныеЛистовА.Количество() Цикл 
		НовСтр = ЛистыАВДереве.Добавить();
		ЗаполнитьЗначенияСвойств(НовСтр, ЛистыАВДереве[0]);
		НовСтр.Наименование = "Стр. " + ЛистыАВДереве.Количество();
	КонецЦикла;
	Пока ЭтотОбъект["ДанныеМногостраничныхРазделов"].СвПрККТ.Количество() < ДанныеЛистовА.Количество() Цикл 
		ЭтотОбъект["ДанныеМногостраничныхРазделов"].СвПрККТ.Добавить(ОбщегоНазначения.СкопироватьРекурсивно(ЭтотОбъект["ДанныеМногостраничныхРазделов"].СвПрККТ[0].Значение));
	КонецЦикла;
	Для Инд = 0 По ДанныеЛистовА.Количество() - 1 Цикл 
		УИД = Новый УникальныйИдентификатор;
		ЛистыАВДереве[Инд].УИД = УИД;
		ЭтотОбъект["ДанныеМногостраничныхРазделов"].СвПрККТ[Инд].Значение.УИД = УИД;
		ЭтотОбъект["ДанныеМногостраничныхРазделов"].СвПрККТ[Инд].Значение.МоделККТ = ДанныеЛистовА[Инд].Значение.МоделККТ;
		ЭтотОбъект["ДанныеМногостраничныхРазделов"].СвПрККТ[Инд].Значение.НомерККТ = ДанныеЛистовА[Инд].Значение.НомерККТ;
		ЭтотОбъект["ДанныеМногостраничныхРазделов"].СвПрККТ[Инд].Значение.РегНомерККТ = ДанныеЛистовА[Инд].Значение.РегНомерККТ;
		ЭтотОбъект["ДанныеМногостраничныхРазделов"].СвПрККТ[Инд].Значение.ДатаРегККТ = ДанныеЛистовА[Инд].Значение.ДатаРегККТ;
		ЭтотОбъект["ДанныеМногостраничныхРазделов"].СвПрККТ[Инд].Значение.СумРасхККТ = ДанныеЛистовА[Инд].Значение.СумРасхККТ;
		Прервать;
	КонецЦикла;
	
	ДанныеЛистовБ = ДанныеПомощника.ДанныеЛистовБ;
	ИтоговыеСуммы = ДеревоСтраниц.ПолучитьЭлементы()[2].ПолучитьЭлементы()[0];
	ЛистыБВДереве = ИтоговыеСуммы.ПолучитьЭлементы();
	Пока ЛистыБВДереве.Количество() < ДанныеЛистовБ.Количество() Цикл 
		НовСтр = ЛистыБВДереве.Добавить();
		ЗаполнитьЗначенияСвойств(НовСтр, ЛистыБВДереве[0]);
		НовСтр.Наименование = "Стр. " + ЛистыБВДереве.Количество();
	КонецЦикла;
	Пока ЭтотОбъект["ДанныеМногостраничныхРазделов"].СвПатСумНалУм.Количество() < ДанныеЛистовБ.Количество() Цикл 
		ЭтотОбъект["ДанныеМногостраничныхРазделов"].СвПатСумНалУм.Добавить(ОбщегоНазначения.СкопироватьРекурсивно(ЭтотОбъект["ДанныеМногостраничныхРазделов"].СвПатСумНалУм[0].Значение));
	КонецЦикла;
	Для Инд = 0 По ДанныеЛистовБ.Количество() - 1 Цикл 
		УИД = Новый УникальныйИдентификатор;
		ЛистыБВДереве[Инд].УИД = УИД;
		ЭтотОбъект["ДанныеМногостраничныхРазделов"].СвПатСумНалУм[Инд].Значение.УИД = УИД;
		ЭтотОбъект["ДанныеМногостраничныхРазделов"].СвПатСумНалУм[Инд].Значение.НомерПат = ДанныеЛистовБ[Инд].Значение.Стр120;
		ЭтотОбъект["ДанныеМногостраничныхРазделов"].СвПатСумНалУм[Инд].Значение.ДатаВыдПат = ДанныеЛистовБ[Инд].Значение.Стр130;
		ЭтотОбъект["ДанныеМногостраничныхРазделов"].СвПатСумНалУм[Инд].Значение.СумПерСрНалУм = ДанныеЛистовБ[Инд].Значение.Стр140;
		ЭтотОбъект["ДанныеМногостраничныхРазделов"].СвПатСумНалУм[Инд].Значение.ПерСрУплНал = ДанныеЛистовБ[Инд].Значение.Стр150;
		ЭтотОбъект["ДанныеМногостраничныхРазделов"].СвПатСумНалУм[Инд].Значение.СумРасхККТПерУмНал = ДанныеЛистовБ[Инд].Значение.Стр160;
		ЭтотОбъект["ДанныеМногостраничныхРазделов"].СвПатСумНалУм[Инд].Значение.ВтСрУплНал = ДанныеЛистовБ[Инд].Значение.Стр170;
		ЭтотОбъект["ДанныеМногостраничныхРазделов"].СвПатСумНалУм[Инд].Значение.СумВтСрНалУм = ДанныеЛистовБ[Инд].Значение.Стр180;
		ЭтотОбъект["ДанныеМногостраничныхРазделов"].СвПатСумНалУм[Инд].Значение.ТрСрУплНал = ДанныеЛистовБ[Инд].Значение.Стр190;
		ЭтотОбъект["ДанныеМногостраничныхРазделов"].СвПатСумНалУм[Инд].Значение.СумРасхККТВтУмНал = ДанныеЛистовБ[Инд].Значение.Стр200;
	КонецЦикла;
КонецПроцедуры

&НаСервере
Процедура ОчисткаОтчета() Экспорт
	УведомлениеОСпецрежимахНалогообложения.ОчисткаОтчетаДействия(Новый Структура("Форма", ЭтотОбъект));
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьНачальныеДанные() Экспорт
	ДанныеУведомленияТитульный = ЭтотОбъект["ДанныеУведомления"]["Титульная"];
	ДанныеУведомленияТитульный.Вставить("КодНО", ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Объект.РегистрацияВИФНС, "Код"));
	Объект.ДатаПодписи = ТекущаяДатаСеанса();
	ДанныеУведомленияТитульный.Вставить("ДАТА_ПОДПИСИ", Объект.ДатаПодписи);
	
	СтрокаСведений = "ИННФЛ,ФИО,ТелДом,ФамилияИП,ИмяИП,ОтчествоИП,ОГРН";
	СведенияОбОрганизации = РегламентированнаяОтчетностьВызовСервера.ПолучитьСведенияОбОрганизации(Объект.Организация, Объект.ДатаПодписи, СтрокаСведений);
	ДанныеУведомленияТитульный.Вставить("ИННШапка", СведенияОбОрганизации.ИННФЛ);
	ДанныеУведомленияТитульный.Вставить("Фамилия", СведенияОбОрганизации.ФамилияИП);
	ДанныеУведомленияТитульный.Вставить("Имя", СведенияОбОрганизации.ИмяИП);
	ДанныеУведомленияТитульный.Вставить("Отчество", СведенияОбОрганизации.ОтчествоИП);
	ДанныеУведомленияТитульный.Вставить("Тлф", СведенияОбОрганизации.ТелДом);
	ДанныеУведомленияТитульный.Вставить("ОГРН", СведенияОбОрганизации.ОГРН);
	
	Реквизиты = РегистрацияВНОСервер.ДанныеРегистрации(Объект.РегистрацияВИФНС);
	ДанныеУведомленияТитульный.Вставить("КодНО", Реквизиты.Код);
	
	Если ЗначениеЗаполнено(Реквизиты.Представитель) Тогда
		УстановитьПредставителяПоФизЛицу(Реквизиты.Представитель);
		ДанныеУведомленияТитульный.Вставить("ПРИЗНАК_НП_ПОДВАЛ", "2");
		ДанныеУведомленияТитульный.Вставить("НаимДок", Реквизиты.ДокументПредставителя);
	Иначе
		УстановитьПредставителяПоОрганизации();
		ДанныеУведомленияТитульный.Вставить("ПРИЗНАК_НП_ПОДВАЛ", "1");
		ДанныеУведомленияТитульный.Вставить("НаимДок", "");
	КонецЕсли;
КонецПроцедуры

&НаСервере
Процедура СформироватьДеревоСтраниц() Экспорт
	ДеревоСтраниц.ПолучитьЭлементы().Очистить();
	КорневойУровень = ДеревоСтраниц.ПолучитьЭлементы();
	
	Стр001 = КорневойУровень.Добавить();
	Стр001.Наименование = "Титульная страница";
	Стр001.ИндексКартинки = 1;
	Стр001.ИмяМакета = "Форма2024_1_Титульная";
	Стр001.Многостраничность = Ложь;
	Стр001.Многострочность = Ложь;
	Стр001.УИД = Новый УникальныйИдентификатор;
	Стр001.ИДНаименования = "Титульная";
	
	Стр001 = КорневойУровень.Добавить();
	Стр001.Наименование = "Листы А";
	Стр001.ИндексКартинки = 1;
	Стр001.ИндексКартинки = 1;
	Стр001.Многостраничность = Истина;
	Стр001.Многострочность = Истина;
	
	Стр001 = Стр001.ПолучитьЭлементы().Добавить();
	Стр001.Наименование = "Стр. 1";
	Стр001.ИндексКартинки = 1;
	Стр001.ИмяМакета = "Форма2024_1_СвПрККТ";
	Стр001.Многостраничность = Истина;
	Стр001.Многострочность = Ложь;
	Стр001.УИД = Новый УникальныйИдентификатор;
	Стр001.ИДНаименования = "СвПрККТ";
	
	Стр001 = КорневойУровень.Добавить();
	Стр001.Наименование = "Итоговые суммы";
	Стр001.ИндексКартинки = 1;
	Стр001.ИмяМакета = "Форма2024_1_УмСумНалПрККТ";
	Стр001.Многостраничность = Ложь;
	Стр001.Многострочность = Ложь;
	Стр001.УИД = Новый УникальныйИдентификатор;
	Стр001.ИДНаименования = "УмСумНалПрККТ";
	
	Стр001 = Стр001.ПолучитьЭлементы().Добавить();
	Стр001.Наименование = "Листы Б";
	Стр001.ИндексКартинки = 1;
	Стр001.ИндексКартинки = 1;
	Стр001.Многостраничность = Истина;
	Стр001.Многострочность = Истина;
	
	Стр001 = Стр001.ПолучитьЭлементы().Добавить();
	Стр001.Наименование = "Стр. 1";
	Стр001.ИндексКартинки = 1;
	Стр001.ИмяМакета = "Форма2024_1_СвПатСумНалУм";
	Стр001.Многостраничность = Истина;
	Стр001.Многострочность = Ложь;
	Стр001.УИД = Новый УникальныйИдентификатор;
	Стр001.ИДНаименования = "СвПатСумНалУм";
КонецПроцедуры

&НаКлиенте
Процедура ДеревоСтраницПриАктивизацииСтрокиЗавершение() Экспорт 
	ПредУИД = ЭтотОбъект["УИДПереключение"];
	Элемент = Элементы.ДеревоСтраниц;
	
	Если Элемент.ТекущиеДанные.Многостраничность Тогда 
		ИмяМакета = УведомлениеОСпецрежимахНалогообложенияКлиент.ПолучитьИмяВыводимогоМакета(Элемент.ТекущиеДанные);
		ПоказатьТекущуюМногостраничнуюСтраницу(ИмяМакета, ПредУИД);
	Иначе 
		ПоказатьТекущуюСтраницу(Элемент.ТекущиеДанные.ИмяМакета, Элемент.ТекущиеДанные.МногострочныеЧасти, ПредУИД);
	КонецЕсли;
КонецПроцедуры

&НаСервере
Процедура ПоказатьТекущуюМногостраничнуюСтраницу(ИмяМакета, ПредУИД)
	УведомлениеОСпецрежимахНалогообложения.ПоказатьТекущуюМногостраничнуюСтраницу(ЭтотОбъект, ИмяМакета);
	СумРасхККТ = ПредставлениеУведомления.Области.Найти("СумРасхККТ");
	Если СумРасхККТ <> Неопределено Тогда 
		СумРасхККТ.ЦветТекста = ?(Число(СумРасхККТ.Значение) > 28000, Новый Цвет(255,0,0), Новый Цвет(0,0,0));
	КонецЕсли;
КонецПроцедуры

&НаСервере
Процедура ПоказатьТекущуюСтраницу(ИмяМакета, МногострочныеЧасти, ПредУИД)
	УведомлениеОСпецрежимахНалогообложения.ПоказатьТекущуюСтраницу(ЭтотОбъект, ИмяМакета, ПредУИД);
КонецПроцедуры

&НаСервере
Процедура УстановитьДанныеПоРегистрацииВИФНС()
	Реквизиты = РегистрацияВНОСервер.ДанныеРегистрации(Объект.РегистрацияВИФНС);
	ПредставлениеУведомления.Области["КодНО"].Значение = Реквизиты.Код;
	Если ЗначениеЗаполнено(Реквизиты.Представитель) Тогда
		УстановитьПредставителяПоФизЛицу(Реквизиты.Представитель);
		ПредставлениеУведомления.Области["ПРИЗНАК_НП_ПОДВАЛ"].Значение = "2";
		ПредставлениеУведомления.Области["НаимДок"].Значение = Реквизиты.ДокументПредставителя;
	Иначе
		УстановитьПредставителяПоОрганизации();
		ПредставлениеУведомления.Области["ПРИЗНАК_НП_ПОДВАЛ"].Значение = "1";
		ПредставлениеУведомления.Области["НаимДок"].Значение = "";
	КонецЕсли;
	
	ДанныеУведомленияТитульный = ЭтотОбъект["ДанныеУведомления"]["Титульная"];
	ДанныеУведомленияТитульный.Вставить("ПРИЗНАК_НП_ПОДВАЛ", ПредставлениеУведомления.Области["ПРИЗНАК_НП_ПОДВАЛ"].Значение);
	ДанныеУведомленияТитульный.Вставить("НаимДок", ПредставлениеУведомления.Области["НаимДок"].Значение);
	ДанныеУведомленияТитульный.Вставить("КодНО", ПредставлениеУведомления.Области["КодНО"].Значение);
	ДанныеУведомленияТитульный.Вставить("ДАТА_ПОДПИСИ", ПредставлениеУведомления.Области["ДАТА_ПОДПИСИ"].Значение);
КонецПроцедуры

&НаСервере
Процедура УстановитьПредставителяПоФизЛицу(Физлицо)
	ДанныеУведомленияТитульный = ЭтотОбъект["ДанныеУведомления"]["Титульная"];
	Если ЗначениеЗаполнено(Физлицо) Тогда 
		ДанныеПредставителя = РегламентированнаяОтчетностьПереопределяемый.ПолучитьСведенияОФизЛице(Физлицо, , Объект.ДатаПодписи);
		Объект.ПодписантФамилия = СокрЛП(ДанныеПредставителя.Фамилия);
		Объект.ПодписантИмя = СокрЛП(ДанныеПредставителя.Имя);
		Объект.ПодписантОтчество = СокрЛП(ДанныеПредставителя.Отчество);
	Иначе
		Объект.ПодписантФамилия = "";
		Объект.ПодписантИмя = "";
		Объект.ПодписантОтчество = "";
	КонецЕсли;
	
	УстановитьПодписанта();
КонецПроцедуры

&НаСервере
Процедура УстановитьПредставителяПоОрганизации()
	УстановитьПодписанта();
КонецПроцедуры

&НаСервере
Процедура УстановитьПодписанта()
	ДанныеУведомленияТитульный = ЭтотОбъект["ДанныеУведомления"]["Титульная"];
	ФИО_РУКОВОДИТЕЛЯ_ПРЕДСТАВИТЕЛЯ = СокрЛП(Объект.ПодписантФамилия + " " + Объект.ПодписантИмя + " " + Объект.ПодписантОтчество);
	ДанныеУведомленияТитульный.Вставить("ФИО_РУКОВОДИТЕЛЯ_ПРЕДСТАВИТЕЛЯ", ФИО_РУКОВОДИТЕЛЯ_ПРЕДСТАВИТЕЛЯ);
	Если ПредставлениеУведомления.Области.Найти("ФИО_РУКОВОДИТЕЛЯ_ПРЕДСТАВИТЕЛЯ") <> Неопределено Тогда
		ПредставлениеУведомления.Области["ФИО_РУКОВОДИТЕЛЯ_ПРЕДСТАВИТЕЛЯ"].Значение = ФИО_РУКОВОДИТЕЛЯ_ПРЕДСТАВИТЕЛЯ;
	КонецЕсли;
КонецПроцедуры

&НаСервере
Процедура СохранитьДанные() Экспорт
	Если ЗначениеЗаполнено(Объект.Ссылка) И Не Модифицированность Тогда 
		Возврат;
	КонецЕсли;
	
	СтруктураПараметров = УведомлениеОСпецрежимахНалогообложения.СтруктураПараметровДляСохранения(ЭтотОбъект);
	УведомлениеОСпецрежимахНалогообложения.СохранитьДанные(ЭтотОбъект, СтруктураПараметров);
КонецПроцедуры

&НаСервере
Процедура ЗагрузитьДанные(СсылкаНаДанные)
	УведомлениеОСпецрежимахНалогообложения.ЗагрузкаДанныхУведомления(ЭтотОбъект, СсылкаНаДанные);
КонецПроцедуры

&НаКлиенте
Процедура СобратьДанные()
	Стр110 = 0;
	Стр210 = 0;
	
	Для Каждого Стр Из ЭтотОбъект["ДанныеМногостраничныхРазделов"].СвПрККТ Цикл 
		Стр110 = Стр110 + ЭтотОбъект["ОТЧ"].ПривестиЗначение(Стр.Значение.СумРасхККТ);
	КонецЦикла;
	Для Каждого Стр Из ЭтотОбъект["ДанныеМногостраничныхРазделов"].СвПатСумНалУм Цикл 
		Стр210 = Стр210 + ЭтотОбъект["ОТЧ"].ПривестиЗначение(Стр.Значение.СумРасхККТПерУмНал) 
			+ ЭтотОбъект["ОТЧ"].ПривестиЗначение(Стр.Значение.СумВтСрНалУм) 
			+ ЭтотОбъект["ОТЧ"].ПривестиЗначение(Стр.Значение.СумРасхККТВтУмНал);
	КонецЦикла;
	Стр210 = Стр110 - Стр210;
	
	Обл = ПредставлениеУведомления.Области["СумРасхККТ"];
	Обл.Значение = Стр110;
	УведомлениеОСпецрежимахНалогообложенияКлиент.ПриИзмененииСодержимогоОбласти(ЭтотОбъект, Обл, Ложь);
	Обл = ПредставлениеУведомления.Области["СумРасхККТПревНал"];
	Обл.Значение = Стр210;
	УведомлениеОСпецрежимахНалогообложенияКлиент.ПриИзмененииСодержимогоОбласти(ЭтотОбъект, Обл, Ложь);
КонецПроцедуры

&НаСервере
Процедура СкопироватьСтраницуНаСервере()
	УведомлениеОСпецрежимахНалогообложения.КопироватьСтраницуУведомления(ЭтотОбъект, Истина);
КонецПроцедуры

&НаКлиенте
Процедура СкопироватьСтраницуНаКлиенте() Экспорт 
	СкопироватьСтраницуНаСервере();
КонецПроцедуры

&НаКлиенте
Процедура ДобавитьСтраницу(Команда) Экспорт 
	ДобавитьСтраницуНаСервере();
КонецПроцедуры

&НаСервере
Процедура ДобавитьСтраницуНаСервере()
	УведомлениеОСпецрежимахНалогообложения.ДобавитьСтраницуУведомления(ЭтотОбъект);
КонецПроцедуры

&НаКлиенте
Процедура УдалитьСтраницу() Экспорт
	ЭтотОбъект["УдалениеСтраницы"] = Истина;
	УдалитьСтраницуНаСервере();
	ЭтотОбъект["УдалениеСтраницы"] = Ложь;
КонецПроцедуры

&НаСервере
Процедура УдалитьСтраницуНаСервере()
	УведомлениеОСпецрежимахНалогообложения.УдалитьСтраницуНаСервере(ЭтотОбъект);
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаКодаНОЗавершение(Результат, ДополнительныеПараметры) Экспорт
	Если Результат <> Неопределено Тогда 
		Объект.РегистрацияВИФНС = Результат;
		УстановитьДанныеПоРегистрацииВИФНС();
		Модифицированность = Истина;
	КонецЕсли;
КонецПроцедуры

&НаСервере
Процедура ПриЗакрытииНаСервере()
	СохранитьДанные();	Если Модифицированность Тогда 
		СохранитьДанные();
	КонецЕсли;
	Если ЗначениеЗаполнено(Объект.Ссылка) Тогда
		УведомлениеОбъект = Объект.Ссылка.ПолучитьОбъект();
		Если УведомлениеОбъект.Заблокирован() Тогда 
			УведомлениеОбъект.Разблокировать();
		КонецЕсли;
		РазблокироватьДанныеДляРедактирования(Объект.Ссылка, УникальныйИдентификатор);
	КонецЕсли;
КонецПроцедуры

&НаСервере
Функция СформироватьXMLНаСервере(УникальныйИдентификатор)
	СохранитьДанные();
	Документ = РеквизитФормыВЗначение("Объект");
	Возврат Документ.ВыгрузитьДокумент(УникальныйИдентификатор);
КонецФункции

&НаКлиенте
Процедура СохранитьНаКлиенте(Автосохранение = Ложь,ВыполняемоеОповещение = Неопределено) Экспорт 
	СохранитьДанные();
	Оповестить("Запись_УведомлениеОСпецрежимахНалогообложения", ПараметрыОповещенияОЗаписи(), Объект.Ссылка);
	Если ВыполняемоеОповещение <> Неопределено Тогда
		ВыполнитьОбработкуОповещения(ВыполняемоеОповещение);
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Функция ПараметрыОповещенияОЗаписи()
	ПараметрыОповещения = Новый Структура;
	ПараметрыОповещения.Вставить("Организация", Объект.Организация);
	ПараметрыОповещения.Вставить("РегистрацияВИФНС", Объект.РегистрацияВИФНС);
	ПараметрыОповещения.Вставить("ВидУведомления", Объект.ВидУведомления);
	
	Возврат ПараметрыОповещения;
КонецФункции

&НаСервере
Функция ПроверитьВыгрузкуНаСервере()
	СохранитьДанные();
	Документ = РеквизитФормыВЗначение("Объект");
	Возврат Документ.ПроверитьДокументСВыводомВТаблицу(УникальныйИдентификатор);
КонецФункции

&НаКлиенте
Процедура Подключаемый_ОткрытьПрисоединенныеФайлы(Команда)
	
	РегламентированнаяОтчетностьКлиент.СохранитьУведомлениеИОткрытьФормуПрисоединенныеФайлы(ЭтотОбъект);
	
КонецПроцедуры

&НаСервере
Процедура ПечатьБРОНаСервере()
	УведомлениеОСпецрежимахНалогообложения.ПечатьУведомленияБРО(ЭтотОбъект);
КонецПроцедуры

&НаКлиенте
Процедура ЗагрузитьИзXML(ПараметрыЗагрузкиXML) Экспорт
	ЗагрузитьИзXMLНаСервере(ПараметрыЗагрузкиXML);
	Элементы.ДеревоСтраниц.ТекущаяСтрока = ДеревоСтраниц.ПолучитьЭлементы()[0].ПолучитьИдентификатор();
КонецПроцедуры

&НаСервере
Процедура ЗагрузитьИзXMLНаСервере(ПараметрыЗагрузкиXML)
	ДеревоЗагрузки = УведомлениеОСпецрежимахНалогообложения.СформироватьДеревоЗагрузки(ПараметрыЗагрузкиXML.ПредставлениеXML);
	СхемаВыгрузки = Документы.УведомлениеОСпецрежимахНалогообложения.ИзвлечьСтруктуруXMLУведомления(Объект.ИмяОтчета, "СхемаВыгрузкиФорма2024_1");
	УведомлениеОСпецрежимахНалогообложения.УстановитьОрганизациюПоПараметрамЗагрузки(ЭтотОбъект, ПараметрыЗагрузкиXML);
	
	ДеревоСтраниц.ПолучитьЭлементы().Очистить();
	СформироватьДеревоСтраниц();
	УведомлениеОСпецрежимахНалогообложения.СформироватьСтруктуруДанныхУведомленияНовогоОбразца(ЭтотОбъект);
	
	ДополнительныеПараметры = Новый Структура;
	УведомлениеОСпецрежимахНалогообложения.ЗагрузитьОбычныеСтраницы(ЭтотОбъект, ДеревоЗагрузки, СхемаВыгрузки, ДополнительныеПараметры);
	УведомлениеОСпецрежимахНалогообложения.ЗагрузитьМногостраничныеСтраницы(ЭтотОбъект, ДеревоЗагрузки, СхемаВыгрузки, ДополнительныеПараметры);
КонецПроцедуры

&НаСервере
Процедура ПолучитьСворачиваемыеЭлементы()
	ЭтотОбъект["СворачиваемыеЭлементы"] = ПоместитьВоВременноеХранилище(
		УведомлениеОСпецрежимахНалогообложенияСлужебный.ПолучитьИдентификаторыДляСворачивания(ЭтотОбъект));
КонецПроцедуры

&НаКлиенте
Процедура ЗагрузитьИзФайлаВФормуУведомлениеЗавершение(Результат, ДополнительныеПараметры) Экспорт 
	ПолучитьСворачиваемыеЭлементы();
	УведомлениеОСпецрежимахНалогообложенияКлиент.ПриОткрытии(ЭтотОбъект, Ложь);
КонецПроцедуры

&НаСервере
Процедура РазрешитьРедактированиеРеквизитовОбъекта() Экспорт
	РегламентированнаяОтчетность.РазрешитьРедактированиеРеквизитовОтчета(ЭтотОбъект);
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_РазрешитьРедактированиеРеквизитовОбъекта(Команда)
	РегламентированнаяОтчетностьКлиент.РазрешитьРедактированиеРеквизитовОтчета(ЭтотОбъект);
КонецПроцедуры

#КонецОбласти
